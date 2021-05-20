import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

exports = module.exports = functions.https
    .onRequest(async (req: functions.https.Request, res: functions.Response<any>) => {
      const promises: Array<Promise<any>> = []
      const data: any = req.body
      if (data != null) {
        try {
          // Deletes the device from firestore
          promises.push(admin.firestore().doc(`devices/${data['device']}`).delete())

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
