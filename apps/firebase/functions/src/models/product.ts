import { IAPSource, SubscriptionType } from '../utils/iap_utils'
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
