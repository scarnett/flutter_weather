import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { IAPSource, Purchase } from './iap_constants'

/**
 * In-App-Purchase repository
 */
export class IapRepository {
  /**
   * The default constructor
   * @param {admin.firestore.Firestore} firestore the firestore instance
   */
  constructor(
    private firestore: admin.firestore.Firestore,
  ) { }

  /**
   * Updates some purchase data
   * @param {any} purchaseData the purchase data
   */
  async updatePurchase(
    purchaseData: {
      iapSource: IAPSource
      orderId: string
    } & Partial<Purchase>
  ): Promise<void> {
    const purchaseId: string = `${purchaseData.iapSource}_${purchaseData.orderId}`
    const purchase: admin.firestore.DocumentReference<admin.firestore.DocumentData> = this.firestore
      .collection('purchases')
      .doc(purchaseId)

    await purchase.update(purchaseData)
  }

  /**
   * Saved some purchase data
   * @param {any} purchaseData the purchase data
   */
  async createOrUpdatePurchase(
    purchaseData: {
      iapSource: IAPSource
      orderId: string
    } & Partial<Purchase>
  ): Promise<void> {
    const purchases: admin.firestore.CollectionReference<admin.firestore.DocumentData> = this.firestore.collection(
      'purchases'
    )

    const purchaseId: string = `${purchaseData.iapSource}_${purchaseData.orderId}`
    const purchase: admin.firestore.DocumentReference<admin.firestore.DocumentData> = purchases.doc(purchaseId)
    await purchase.set(purchaseData)
  }

  /**
   * Expires a subscription
   * @return {Promise<void>}
   */
  async expireSubscriptions(): Promise<void> {
    const documents: admin.firestore.QuerySnapshot<admin.firestore.DocumentData> = await this.firestore
      .collection('purchases')
      .where('expiryDate', '<=', admin.firestore.Timestamp.now())
      .where('status', '==', 'ACTIVE')
      .get()

    if (!documents.size) {
      return
    }

    const writeBatch: admin.firestore.WriteBatch = this.firestore.batch()
    documents.docs.forEach((doc) => writeBatch.update(doc.ref, { status: 'EXPIRED' }))

    await writeBatch.commit()
    functions.logger.log(`Expired ${documents.size} subscriptions`)
  }
}
