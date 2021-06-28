import * as functions from 'firebase-functions'

exports = module.exports = functions.https.onRequest(
  async (req: functions.https.Request, res: functions.Response<any>) => {
    res.status(200).send('ok')
  }
)
