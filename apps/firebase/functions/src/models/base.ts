/**
 * The base model
 */
export class BaseModel {
  /**
   * Converts a json string into an object
   * @param {any} json the json
   * @return {any} with the object
   */
  static fromJSON(json: any): any {
    return JSON.parse(json)
  }

  /**
   * Converts an object into a json string
   * @return {string} with the json string
   */
  toJSON(): string {
    return JSON.stringify(this)
  }
}
