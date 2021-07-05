import * as functions from 'firebase-functions'
import { google } from 'googleapis'

const rp: any = require('request-promise')
const RC_SCOPES: string[] = [
  'https://www.googleapis.com/auth/firebase.remoteconfig',
  'https://www.googleapis.com/auth/userinfo.email',
  'https://www.googleapis.com/auth/firebase.database',
  'https://www.googleapis.com/auth/androidpublisher',
]

/**
 * Gets the remote configuration url
 * @return {string} with the remote configuration url
 */
export function remoteConfigUrl(): string {
  const host: string = 'firebaseremoteconfig.googleapis.com'
  return `https://${host}/v1/projects/${functions.config().project.id}/remoteConfig`
}

/**
 * Gets the remote configuration
 * @return {Promise<any>} with the remote configuration
 */
export async function getRemoteConfig(): Promise<any> {
  return getAccessToken()
    .then((accessToken: any) => {
      const options: any = {
        uri: remoteConfigUrl(),
        headers: {
          'Authorization': `Bearer ${accessToken}`,
        },
        json: true,
      }

      return rp(options)
        .then((config: any) => Promise.resolve(config))
        .catch((err: any) => Promise.resolve(null))
    })
    .catch((error: any) => {
      functions.logger.error(error)
      return Promise.resolve(null)
    })
}

/**
 * Gets an access token
 * @return {any} with the token
 */
export function getAccessToken(): any {
  return new Promise((resolve, reject) => {
    const key: any = require(`../keys/${functions.config().auth.key.filename}`)
    const jwtClient: any = new google.auth.JWT(key.client_email, undefined, key.private_key, RC_SCOPES, undefined)
    jwtClient.authorize((err: any, tokens: any) => {
      if (err) {
        reject(err)
        return
      }

      resolve(tokens.access_token)
    })
  })
}
