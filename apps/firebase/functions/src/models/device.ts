import * as admin from 'firebase-admin'
import { BaseModel } from './base'
import { FCM } from './fcm'
import { PushNotificationExtras } from './push_notification'
import { Units } from './units'

/**
 * The device model
 */
export class Device extends BaseModel {
  fcm?: FCM
  period?: string
  pushNotification?: string
  pushNotificationExtras?: PushNotificationExtras
  units?: Units
  lastUpdated?: admin.firestore.Timestamp
  lastPushDate?: admin.firestore.Timestamp
}
