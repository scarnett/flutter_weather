import { NonSubscriptionPurchase, SubscriptionPurchase } from '../models/purchase'

export const ANDROID_PACKAGE_ID = 'com.example.dashclicker'
export const APP_STORE_SHARED_SECRET = '8ad6de58ec884ef0ad9fa0c239228640'
export const CLOUD_REGION = 'europe-west1'
export const GOOGLE_PLAY_PUBSUB_BILLING_TOPIC = 'play_billing'

export type IAPSource = 'google_play' | 'app_store'
export type NonSubscriptionStatus = 'PENDING' | 'COMPLETED' | 'CANCELLED'
export type SubscriptionStatus = 'PENDING' | 'ACTIVE' | 'EXPIRED'
export type SubscriptionType = 'NON_SUBSCRIPTION' | 'SUBSCRIPTION'
export type Purchase = NonSubscriptionPurchase | SubscriptionPurchase
