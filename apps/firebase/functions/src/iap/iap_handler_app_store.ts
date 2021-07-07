import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import * as appleReceiptVerify from 'node-apple-receipt-verify'
import { Product } from '../models/product'
import { APP_STORE_SHARED_SECRET } from './iap_constants'
import { PurchaseHandler } from './iap_handler'
import { IapRepository } from './iap_repository'

/**
 * The App Store purchase handler
 */
export class AppStorePurchaseHandler extends PurchaseHandler {
  /**
   * The default constructor
   * @param {IapRepository} iapRepository the iap repository
   */
  constructor(
    private iapRepository: IapRepository,
  ) {
    super()

    appleReceiptVerify.config({
      verbose: false,
      secret: APP_STORE_SHARED_SECRET,
      extended: true,
      environment: ['sandbox'], // Optional, defaults to ['production'],
      excludeOldTransactions: true,
    })
  }

  /**
   * Handles a non-subscription purchase
   * @param {Product} productData the product 
   * @param {string} token the token
   */
  async handleNonSubscription(
    productData: Product,
    token: string,
  ): Promise<boolean> {
    throw new Error('Method not implemented.')
  }

  /**
   * Handles a subscription purchase
   * @param {Product} productData the product 
   * @param {string} token the token
   */
  async handleSubscription(
    productData: Product,
    token: string,
  ): Promise<boolean> {
    let products: appleReceiptVerify.PurchasedProducts[]

    try {
      products = await appleReceiptVerify.validate({ receipt: token })
    } catch (e) {
      if (e instanceof appleReceiptVerify.EmptyError) {
        // Receipt is valid but it is now empty.
        functions.logger.warn(
          'Received valid empty receipt')

        return true
      } else if (e instanceof appleReceiptVerify.ServiceUnavailableError) {
        functions.logger.warn(
          'App store is currently unavailable, could not validate')

        // Handle app store services not being available
        return false
      }

      return false
    }

    // Process the received products
    for (const product of products) {
      // Skip processing the product if it is unknown
      if (!productData) {
        continue
      }

      // Process the product
      switch (productData.type) {
        case 'SUBSCRIPTION':
          await this.iapRepository.createOrUpdatePurchase({
            type: productData.type,
            iapSource: 'app_store',
            orderId: product.transactionId,
            productId: product.productId,
            purchaseDate: admin.firestore.Timestamp.fromMillis(product.purchaseDate),
            expiryDate: admin.firestore.Timestamp.fromMillis(product.expirationDate ?? 0),
            status: ((product.expirationDate ?? 0) <= Date.now()) ? 'EXPIRED' : 'ACTIVE',
          })

          break

        case 'NON_SUBSCRIPTION':
          await this.iapRepository.createOrUpdatePurchase({
            type: productData.type,
            iapSource: 'app_store',
            orderId: product.transactionId,
            productId: product.productId,
            purchaseDate: admin.firestore.Timestamp.fromMillis(product.purchaseDate),
            status: 'COMPLETED',
          })

          break
      }
    }

    return true
  }
}