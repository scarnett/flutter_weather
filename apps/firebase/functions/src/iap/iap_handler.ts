import * as productModel from '../models/product'

/**
 * The purchase handler
 */
export abstract class PurchaseHandler {
  /**
   * Verifies a purchase
   * @param {productModel.Product} product the product
   * @param {string} token the token
   * @return {Promise<boolean>} with the purchase verification status
   */
  async verifyPurchase(
    product: productModel.Product,
    token: string,
  ): Promise<boolean> {
    switch (product.type) {
      case 'SUBSCRIPTION':
        return this.handleSubscription(product, token)

      case 'NON_SUBSCRIPTION':
        return this.handleNonSubscription(product, token)

      default:
        return false
    }
  }

  abstract handleNonSubscription(
    product: productModel.Product,
    token: string,
  ): Promise<boolean>

  abstract handleSubscription(
    product: productModel.Product,
    token: string,
  ): Promise<boolean>
}
