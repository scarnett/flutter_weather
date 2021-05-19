import { BaseModel } from './base'

/**
 * The location model
 */
export class Location extends BaseModel {
  id?: string
  latitude?: number
  longitude?: number
  name?: string
}
