import * as functions from 'firebase-functions'

/**
 * This pushes current forecast notifications to devices.
 */
exports = module.exports = functions.pubsub
    .schedule('0 * * * *') // Every hour
    .timeZone('America/New_York')
    .onRun(async (context: functions.EventContext) => {
      return await Promise.resolve('ok')
    })
