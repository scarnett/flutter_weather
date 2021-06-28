import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import { DateTime } from 'luxon'

exports = module.exports = functions.https.onRequest(
  async (req: functions.https.Request, res: functions.Response<any>) => {
    const promises: Array<Promise<any>> = []
    const data: any = req.body
    if (data != null) {
      try {
        const now: admin.firestore.Timestamp = admin.firestore.Timestamp.now()
        const lastPushDate: DateTime = DateTime.fromJSDate(now.toDate()).startOf('hour')
        const pushNotificationExtras: string = data['pushNotificationExtras']
        const units: string = data['units']

        // Save the device to firestore
        promises.push(
          admin
            .firestore()
            .doc(`devices/${data['device']}`)
            .set(
              {
                period: data['period'],
                pushNotification: data['pushNotification'],
                pushNotificationExtras:
                  pushNotificationExtras == null ?
                    admin.firestore.FieldValue.delete() :
                    JSON.parse(pushNotificationExtras),
                units: units == null ? admin.firestore.FieldValue.delete() : JSON.parse(units),
                fcm: {
                  token: data['fcmToken'],
                },
                lastUpdated: now.toDate(),
                lastPushDate: lastPushDate.toJSDate(),
              },
              {
                merge: true,
              }
            )
        )

        return Promise.all(promises)
          .then(() => {
            res.status(200).send('ok')
          })
          .catch((error: any) => {
            functions.logger.error(error)
            res.status(500).send('error')
          })
      } catch (error) {
        functions.logger.error(error)
        res.status(500).send('error')
      }
    }

    res.status(200).send('ok')
  }
)
