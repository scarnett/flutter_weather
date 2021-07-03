import * as admin from 'firebase-admin'
import * as deviceModel from '../models/device'
import * as messageModel from '../models/message'

/**
 * Pushes a message to a device
 * @param {deviceModel.Device} device the device that the message will be sent too
 * @param {messageModel.Message | null} messageData the message data
 * @param {string} priority the priority
 * @return {Promise<string>}
 */
export async function pushMessage(
  device: deviceModel.Device,
  messageData: messageModel.Message | null,
  priority: string = 'high',
): Promise<String | null> {
  if (messageData === null) {
    return Promise.resolve(null)
  }

  const payload: any = {
    android: {
      notification: {
        priority: priority,
        color: messageData.color,
        sound: messageData.sound,
        icon: messageData.icon,
        tag: messageData.tag,
      },
    },
    data: {
      // ...messageData.data,
      // 'send_date': Date.now().toString(),
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    },
    notification: {
      title: messageData.title,
      body: messageData.body,
    },
    token: device.fcm?.token,
  }

  // Send push notification
  return admin.messaging().send(payload)
}
