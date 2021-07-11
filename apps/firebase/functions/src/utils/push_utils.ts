import * as admin from 'firebase-admin'
import * as i18n from 'i18n'
import * as deviceModel from '../models/device'
import * as messageModel from '../models/message'
import * as forecastUtils from '../utils/forecast_utils'
import * as stringUtils from '../utils/string_utils'

/**
 * Pushes a message to a device
 * @param {deviceModel.Device} device the device that the message will be sent too
 * @param {messageModel.Message | null} messageData the message data
 * @param {string} priority the priority
 * @return {Promise<string>} with a unique message id
 */
export async function pushMessage(
  device: deviceModel.Device,
  messageData: messageModel.Message | null,
): Promise<String | null> {
  if (messageData === null) {
    return Promise.resolve(null)
  }

  const payload: any = {
    android: {
      priority: messageData.priorityAndroid,
      notification: {
        color: messageData.color,
        sound: messageData.sound,
        icon: messageData.icon,
        tag: messageData.tag,
        image: messageData.image,
      },
    },
    apns: {
      headers: {
        'apns-priority': messageData.priorityIos,
      },
      payload: {
        aps: {
          sound: messageData.sound,
        },
      },
    },
    data: {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    },
    notification: {
      title: messageData.title,
      body: messageData.body,
    },
    token: device.fcm?.token,
  }

  // Send push notification
  return admin.messaging().send(payload)
}

/**
 * Gets the push notification message text
 * @param {any} response the http response
 * @param {deviceModel.Device} device the device that the message will be sent too
 * @param {boolean} showUnits the show units status
 * @return {String} with the push notification message text
 */
export function getMessageText(
  response: any,
  device: deviceModel.Device,
  showUnits: boolean,
): String {
  const text: string = i18n.__('{{temp}}{{temperatureUnit}} in {{cityName}} - {{condition}}', {
    temp: response.main.temp.toFixed(),
    temperatureUnit: forecastUtils.getTemperatureUnit(device.units?.temperature, showUnits),
    cityName: response.name,
    condition: stringUtils.capitalize(response.weather[0].description),
  })

  return text
}

/**
 * Gets the push notification body text
 * @param {any} response the http response
 * @param {deviceModel.Device} device the device that the message will be sent too
 * @param {boolean} showUnits the show units status
 * @return {String} with the push notification body text
 */
export function getBodyText(
  response: any,
  device: deviceModel.Device,
  showUnits: boolean,
): String {
  const text: string =
    i18n.__('High {{highTemp}}{{temperatureUnit}} | Low {{lowTemp}}{{temperatureUnit}}', {
      highTemp: response.main.temp_max.toFixed(),
      lowTemp: response.main.temp_min.toFixed(),
      temperatureUnit: forecastUtils.getTemperatureUnit(device.units?.temperature, showUnits),
    })

  return text
}

/**
 * Gets the push notification image url
 * @param {any} response the http response
 * @param {boolean} large the large icon status
 * @return {String} with the push notification image url
 */
export function getImageUrl(
  response: any,
  large: boolean = true,
): String {
  return `https://openweathermap.org/img/wn/${response.weather[0].icon}${large ? '@2x' : ''}.png`
}