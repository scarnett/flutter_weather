import * as productModel from '../models/product'
import { NonSubscriptionPurchase, SubscriptionPurchase } from '../models/purchase'

export type IAPSource = 'google_play' | 'app_store'
export type NonSubscriptionStatus = 'PENDING' | 'COMPLETED' | 'CANCELLED'
export type SubscriptionStatus = 'PENDING' | 'ACTIVE' | 'EXPIRED'
export type SubscriptionType = 'NON_SUBSCRIPTION' | 'SUBSCRIPTION'
export type Purchase = NonSubscriptionPurchase | SubscriptionPurchase

/**
 * The purchase handler
 */
export abstract class PurchaseHandler {
  /**
   * Verifies a purchase
   * @param {string} deviceId the device id
   * @param {productModel.Product} product the product
   * @param {string} token the token
   * @return {Promise<boolean>} with the purchase verification status
   */
  async verifyPurchase(deviceId: string, product: productModel.Product, token: string): Promise<boolean> {
    switch (product.type) {
      case 'SUBSCRIPTION':
        return this.handleSubscription(deviceId, product, token)

      case 'NON_SUBSCRIPTION':
        return this.handleNonSubscription(deviceId, product, token)

      default:
        return false
    }
  }

  abstract handleNonSubscription(userId: string, product: productModel.Product, token: string): Promise<boolean>

  abstract handleSubscription(userId: string, product: productModel.Product, token: string): Promise<boolean>
}
