import * as functions from 'firebase-functions'

exports = module.exports = functions.https
    .onRequest((req: functions.https.Request, res: functions.Response<any>) => {
      res.send('Hello World')
    })
