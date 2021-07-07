import * as admin from 'firebase-admin'
import { IAPSource, NonSubscriptionStatus, SubscriptionStatus } from '../iap/iap_constants'

export interface BasePurchase {
  iapSource: IAPSource
  orderId: string
  productId: string
  purchaseDate: admin.firestore.Timestamp
}

export interface NonSubscriptionPurchase extends BasePurchase {
  type: 'NON_SUBSCRIPTION'
  status: NonSubscriptionStatus
}

export interface SubscriptionPurchase extends BasePurchase {
  type: 'SUBSCRIPTION'
  expiryDate: admin.firestore.Timestamp
  status: SubscriptionStatus
}
