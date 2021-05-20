import * as admin from 'firebase-admin'
import { DateTime } from 'luxon'
import * as deviceModel from '../models/device'

/**
 * Checks to see if we can push a message to a device
 * @param {deviceModel.Device} device the device
 * @param {Date} minDate the min date to compare against
 * @return {boolean} with the status
 */
export function canPushForecast(device: deviceModel.Device, minDate: Date): boolean {
  const lastPushDateTs: admin.firestore.Timestamp | undefined = device.lastPushDate
  if (lastPushDateTs != null) {
    const lastPushDate: DateTime = DateTime.fromJSDate(lastPushDateTs.toDate())
    const hours: number = getPeriodHours(device)
    if (lastPushDate.plus({hours: hours}) <= DateTime.fromJSDate(minDate)) {
      return true
    }

    return false
  }

  return true
}

/**
 * Gets the hours for a period
 * @param {deviceModel.Device} device the device
 * @return {number} with the hours
 */
export function getPeriodHours(device: deviceModel.Device): number {
  switch (device.period) {
    case '1hr':
      return 1

    case '2hrs':
      return 2

    case '3hrs':
      return 3

    case '4hrs':
      return 4

    case '5hrs':
      return 5

    default:
      return 0
  }
}
