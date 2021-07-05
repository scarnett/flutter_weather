import { IAPSource, SubscriptionType } from '../iap/iap_constants'
import { BaseModel } from './base'

/**
 * The product model
 */
export class Product extends BaseModel {
  id?: string
  source?: IAPSource
  type?: SubscriptionType
  enabled?: boolean
}
