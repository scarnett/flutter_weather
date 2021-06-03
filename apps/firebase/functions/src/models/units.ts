import { BaseModel } from './base'

/**
 * The units model
 */
export class Units extends BaseModel {
  temperature?: 'imperial' | 'metric' | 'standard'
  windSpeed?: 'mph' | 'kmh'
}
