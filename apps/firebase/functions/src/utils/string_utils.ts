/**
 * Capitalizes a string
 * @param {string} str the string
 * @return {string} with the capitalized string
 */
export function capitalize(str: string): string {
  return str.charAt(0).toUpperCase() + str.slice(1)
}
