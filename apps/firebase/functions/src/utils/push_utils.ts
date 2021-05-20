import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
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
): Promise<string | null> {
  if (messageData === null) {
    return Promise.resolve(null)
  }

  const promises: Array<Promise<any>> = []
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
  promises.push(admin.messaging().send(payload))

  return Promise.all(promises)
      .then(() => {
        return Promise.resolve('ok')
      })
      .catch((error: any) => {
        functions.logger.error(error)
        return Promise.resolve('error')
      })
}
