import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { GoogleAuth } from 'google-auth-library'
import { androidpublisher_v3 as AndroidPublisherApi } from 'googleapis'
import credentials from '../assets/service-account.json'
import { Product } from '../models/product'
import { SubscriptionPurchase } from '../models/purchase'
import { ANDROID_PACKAGE_ID, SubscriptionStatus } from './iap_constants'
import { PurchaseHandler } from './iap_handler'
import { IapRepository } from './iap_repository'

/**
 * The Google Play purchase handler
 */
export class GooglePlayPurchaseHandler extends PurchaseHandler {
  private androidPublisher: AndroidPublisherApi.Androidpublisher

  /**
   * The default constructor
   * @param {IapRepository} iapRepository the iap repository
   */
  constructor(
    private iapRepository: IapRepository,
  ) {
    super()

    this.androidPublisher = new AndroidPublisherApi.Androidpublisher({
      auth: new GoogleAuth({
        credentials,
        scopes: ['https://www.googleapis.com/auth/androidpublisher'],
      }),
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
    try {
      const response = await this.androidPublisher.purchases.subscriptions
        .get(
          {
            packageName: ANDROID_PACKAGE_ID,
            subscriptionId: productData.id,
            token,
          },
        )

      if (!response.data.orderId) {
        console.error('Could not handle purchase without order id')
        return false
      }

      let orderId: string = response.data.orderId
      const orderIdMatch: RegExpExecArray | null = /^(.+)?[.]{2}[0-9]+$/g.exec(orderId)
      if (orderIdMatch) {
        orderId = orderIdMatch[1]
      }

      functions.logger.warn({
        rawOrderId: response.data.orderId,
        newOrderId: orderId,
      })

      const purchaseData: SubscriptionPurchase = {
        type: 'SUBSCRIPTION',
        iapSource: 'google_play',
        orderId: orderId,
        productId: productData.id!,
        purchaseDate: admin.firestore.Timestamp.fromMillis(parseInt(response.data.startTimeMillis ?? '0', 10)),
        expiryDate: admin.firestore.Timestamp.fromMillis(parseInt(response.data.expiryTimeMillis ?? '0', 10)),
        status: [
          'PENDING', // Payment pending
          'ACTIVE', // Payment received
          'ACTIVE', // Free trial
          'PENDING', // Pending deferred upgrade/downgrade
          'EXPIRED', // Expired or cancelled
        ][response.data.paymentState ?? 4] as SubscriptionStatus,
      }

      try {
        await this.iapRepository.createOrUpdatePurchase(purchaseData)
      } catch (e) {
        functions.logger.error('Could not create or update purchase', { orderId, productId: productData.id })
      }

      return true
    } catch (e) {
      functions.logger.error(e)
      return false
    }
  }
}
