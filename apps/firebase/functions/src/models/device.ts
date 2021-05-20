import * as admin from 'firebase-admin'
import { BaseModel } from './base'
import { FCM } from './fcm'
import { PushNotificationExtras } from './push_notification'

/**
 * The device model
 */
export class Device extends BaseModel {
  fcm?: FCM
  period?: string
  pushNotification?: string
  pushNotificationExtras?: PushNotificationExtras
  temperatureUnit?: 'imperial' | 'metric' | 'standard'
  lastUpdated?: admin.firestore.Timestamp
  lastPushDate?: admin.firestore.Timestamp
}
