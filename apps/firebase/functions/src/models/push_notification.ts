import { BaseModel } from './base'
import { Location } from './location'

/**
 * The push notification extras model
 */
export class PushNotificationExtras extends BaseModel {
  location?: Location
}
