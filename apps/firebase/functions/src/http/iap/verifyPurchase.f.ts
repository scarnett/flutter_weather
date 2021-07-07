import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { IAPSource } from '../../iap/iap_constants'
import { AppStorePurchaseHandler } from '../../iap/iap_handler_app_store'
import { GooglePlayPurchaseHandler } from '../../iap/iap_handler_google_play'
import { IapRepository } from '../../iap/iap_repository'
import * as productModel from '../../models/product'

interface VerifyPurchaseParams {
  source: IAPSource
  verificationData: string
  productId: string
}

exports = module.exports = functions.https.onCall(
  async (
    data: VerifyPurchaseParams,
    context: functions.https.CallableContext,
  ) => {
    // if (!context.auth) {
    //   functions.logger.warn('[httpIapVerifyPurchase] Called when not authenticated')
    //   throw new functions.https.HttpsError('unauthenticated', 'Request was not authenticated.')
    // }

    const productsSnapshot: admin.firestore.QuerySnapshot<admin.firestore.DocumentData> = await admin
      .firestore()
      .collection('products')
      .where('id', '==', data.productId)
      .where('source', '==', data.source)
      .get()

    const productDocuments: admin.firestore.QueryDocumentSnapshot<admin.firestore.DocumentData>[] =
      productsSnapshot.docs

    if (!productDocuments || !productDocuments.length) {
      functions.logger.warn(
        `[httpIapVerifyPurchase] Called for an unknown product id: ` +
        `${data.productId}, source: ${data.source}`
      )

      throw new functions.https.HttpsError(
        'failed-precondition',
        `Product not found id: ${data.productId}, source: ${data.source}`
      )
    }

    productsSnapshot.docs.forEach(async (productDoc: admin.firestore.QueryDocumentSnapshot) => {
      const productData: admin.firestore.DocumentData = productDoc.data()
      const product: productModel.Product = productData as productModel.Product

      // Process the purchase for the product
      return verifyPurchase(exports.iapRepository, data.source, product, data)
    })
  }
)

/**
 * Verifies an iap
 * @param {IapRepository} iapRepository the iap repository
 * @param {IAPSource} source the iap source
 * @param {productModel.Product} product the product
 * @param {VerifyPurchaseParams} data the verification purchase params
 * @return {Promise<boolean>} with the purchase verification status
 */
function verifyPurchase(
  iapRepository: IapRepository,
  source: IAPSource,
  product: productModel.Product,
  data: VerifyPurchaseParams,
): Promise<boolean> {
  switch (source) {
    case 'google_play':
      return new GooglePlayPurchaseHandler(iapRepository).verifyPurchase(product, data.verificationData)

    case 'app_store':
      return new AppStorePurchaseHandler(iapRepository).verifyPurchase(product, data.verificationData)
  }
}
