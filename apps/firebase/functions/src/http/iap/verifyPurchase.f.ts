import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import * as productModel from '../../models/product'
import { IAPSource, verifyPurchase } from '../../utils/iap_utils'

interface VerifyPurchaseParams {
  source: IAPSource
  verificationData: string
  productId: string
}

exports = module.exports = functions.https.onCall(
  async (data: VerifyPurchaseParams, context: functions.https.CallableContext) => {
    if (!context.auth) {
      functions.logger.warn('verifyPurchase called when not authenticated') // TODO! function name
      throw new functions.https.HttpsError('unauthenticated', 'Request was not authenticated.')
    }

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
        `verifyPurchase called for an unknown product id: ${data.productId}, source: ${data.source}`
      ) // TODO! function name
      throw new functions.https.HttpsError(
        'failed-precondition',
        `Product not found id: ${data.productId}, source: ${data.source}`
      )
    }

    productsSnapshot.docs.forEach(async (productDoc: admin.firestore.QueryDocumentSnapshot) => {
      const productData: admin.firestore.DocumentData = productDoc.data()
      const product: productModel.Product = productData as productModel.Product

      // Process the purchase for the product
      return verifyPurchase(exports.iapRepository, data.source, product)
    })
  }
)
