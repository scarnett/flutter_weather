import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'
import * as i18n from 'i18n'
import { DateTime } from 'luxon'
import OpenWeatherMap from 'openweathermap-ts'
import * as deviceModel from '../models/device'
import * as messageModel from '../models/message'
import { PushNotificationExtras } from '../models/push_notification'
import * as forecastUtils from '../utils/forecast_utils'
import * as pushUtils from '../utils/push_utils'
import * as stringUtils from '../utils/string_utils'

/**
 * This pushes current forecast notifications to devices.
 */
exports = module.exports = functions.pubsub
    .schedule('0 * * * *') // Every hour
    .timeZone('America/Chicago')
    .onRun(async (context: functions.EventContext) => {
      try {
        const openWeather: OpenWeatherMap = new OpenWeatherMap({
          apiKey: functions.config().openweathermap.key,
        })

        const now: admin.firestore.Timestamp = admin.firestore.Timestamp.now()
        const lastPushDate: DateTime = DateTime.fromJSDate(now.toDate()).startOf('hour')

        const promises: Array<Promise<any>> = []
        const devicesSnapshot: admin.firestore.QuerySnapshot<admin.firestore.DocumentData> = await admin.firestore()
            .collection('devices')
            .get()

        devicesSnapshot.docs.forEach(async (deviceDoc: admin.firestore.QueryDocumentSnapshot) => {
          const deviceData: admin.firestore.DocumentData = deviceDoc.data()
          const device: deviceModel.Device = deviceData as deviceModel.Device
          if (forecastUtils.canPushForecast(device, now.toDate())) {
            if ((device.pushNotificationExtras != null) && (device.pushNotificationExtras.location != null)) {
              openWeather.setUnits(device.temperatureUnit || 'imperial')

              const extras: PushNotificationExtras = device.pushNotificationExtras
              const response: any = await openWeather.getByGeoCoordinates({
                latitude: extras.location!.latitude,
                longitude: extras.location!.longitude,
                queryType: 'weather',
              })

              if (response != null) {
                // functions.logger.debug(JSON.stringify(response))

                const message: messageModel.Message = new messageModel.Message()
                const messageText: string = i18n.__('{{temp}}{{temperatureUnit}} in {{cityName}}', {
                  temp: response.main.temp.toFixed(),
                  temperatureUnit: forecastUtils.getTemperatureUnit(device.temperatureUnit),
                  cityName: response.name,
                })

                message.title = messageText
                message.body = stringUtils.capitalize(response.weather[0].description)

                // Push the message to the device
                promises.push(pushUtils.pushMessage(device, message)
                    .then((res: any) => Promise.resolve('ok'))
                    .catch((error: any) => {
                      functions.logger.error(error)
                      return Promise.resolve(null)
                    }))

                // Update the last push date in the device document
                promises.push(deviceDoc.ref.update('lastPushDate', lastPushDate.toJSDate()))
              }
            }
          }
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
