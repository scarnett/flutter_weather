import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

exports = module.exports = functions.https
    .onRequest(async (req: functions.https.Request, res: functions.Response<any>) => {
      const promises: Array<Promise<any>> = []
      const data: any = req.body
      if (data != null) {
        try {
          const pushNotificationExtras: string = data['pushNotificationExtras']

          // Save the device to firestore
          promises.push(admin.firestore().doc(`devices/${data['device']}`).set({
            'period': data['period'],
            'pushNotification': data['pushNotification'],
            'pushNotificationExtras': (pushNotificationExtras == null) ?
                admin.firestore.FieldValue.delete() :
                JSON.parse(pushNotificationExtras),
            'temperatureUnit': data['temperatureUnit'],
            'fcm': {
              'token': data['fcmToken'],
            },
            'lastUpdated': admin.firestore.FieldValue.serverTimestamp(),
          }, {
            'merge': true,
          }))

          return Promise.all(promises)
              .then(() => {
                res.status(200).send('ok')
                return
              })
              .catch((error: any) => {
                functions.logger.error(error)
                res.status(500).send('error')
                return
              })
        } catch (error) {
          functions.logger.error(error)
          res.status(500).send('error')
          return
        }
      }

      res.status(200).send('ok')
      return
    })
