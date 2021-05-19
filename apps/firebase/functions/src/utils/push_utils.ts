import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import * as deviceModel from '../models/device'
import * as messageModel from '../models/message'

/**
 * Pushes a message to a device
 * @param {any} toDevice the device that the message will be sent too
 * @param {messageModel.Message | null} messageData the message data
 * @return {Promise<string>}
 */
export async function pushMessage(
    toDevice: deviceModel.Device,
    messageData: messageModel.Message | null,
): Promise<string | null> {
  if (messageData === null) {
    return Promise.resolve(null)
  }

  const promises: Array<Promise<any>> = []

  const msg: any = {
    android: {
      notification: {
        priority: 'high',
        title: messageData.title,
        body: messageData.body,
        color: messageData.color,
        sound: messageData.sound,
        icon: messageData.icon,
      },
    },
    data: {
      // ...messageData.data,
      // 'send_date': Date.now().toString(),
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    },
    token: toDevice.fcm?.token,
  }

  console.log(JSON.stringify(msg))

  // Send push notification
  promises.push(admin.messaging().send(msg))

  try {
    return Promise.all(promises)
        .then(() => {
          return Promise.resolve('ok')
        })
        .catch((error: any) => {
          functions.logger.error(error)
          return Promise.resolve('error')
        })
  } catch (error) {
    functions.logger.error(error)
    return Promise.resolve('error')
  }
}
