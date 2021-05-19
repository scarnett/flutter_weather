/**
 * The base model
 */
export class BaseModel {
  /**
   * Converts a json string into an object
   * @param {any} json the json
   * @return {any} with the object
   */
  static fromJSON(json: any): any {
    return JSON.parse(json)
  }

  /**
   * Converts an object into a json string
   * @return {string} with the json string
   */
  toJSON(): string {
    return JSON.stringify(this)
  }
}

/**
 * The device model
 */
export class Device extends BaseModel {
  fcm?: FCM
  period?: string
  pushNotification?: string
  pushNotificationExtras?: PushNotificationExtras
  lastUpdated?: any
}

/**
 * The fcm model
 */
export class FCM extends BaseModel {
  token?: string
}

/**
 * The pust notification extras model
 */
export class PushNotificationExtras extends BaseModel {
  location?: Location
}

/**
 * The location model
 */
export class Location extends BaseModel {
  id?: string
  latitude?: number
  longitude?: number
  name?: string
}
