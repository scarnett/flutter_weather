import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import * as deviceModel from '../models/device'
import * as messageModel from '../models/message'
import * as pushUtils from '../utils/push_utils'

/**
 * This pushes current forecast notifications to devices.
 */
exports = module.exports = functions.pubsub
    .schedule('0 * * * *') // Every hour
    .timeZone('America/Chicago')
    .onRun(async (context: functions.EventContext) => {
      try {
        const devicesSnapshot = await admin.firestore()
            .collection('devices')
            .get()

        const promises: Array<Promise<any>> = []

        devicesSnapshot.docs.forEach((deviceDoc: admin.firestore.QueryDocumentSnapshot) => {
          const deviceData: admin.firestore.DocumentData = deviceDoc.data()
          const device: deviceModel.Device = deviceData as deviceModel.Device
          const message: messageModel.Message | null = {
            title: 'Hello World', // TODO!
            body: 'This is a test', // TODO!
            color: '#7D33B7', // TODO!
            sound: 'default', // TODO!
            icon: 'app_icon', // TODO!
          }

          promises.push(pushUtils.pushMessage(device, message)
              .then((res: any) => Promise.resolve('ok'))
              .catch((error: any) => {
                functions.logger.error(error)
                return Promise.resolve(null)
              }))
        })

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
    })
