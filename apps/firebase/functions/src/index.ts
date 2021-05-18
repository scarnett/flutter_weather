import camelcase from 'camelcase'
import * as admin from 'firebase-admin'
import * as glob from 'glob'

admin.initializeApp()

const paths: string[] = [
  './firestore/**/*.f.js', // Firestore
  './http/**/*.f.js', // HTTP
  './schedule/*.f.js', // Cron
]

for (const path of paths) {
  const files: string[] = glob.sync(path, {cwd: __dirname, ignore: `./node_modules/**`})
  for (const file of files) {
    processExport(file)
  }
}

/**
 * Processes the export
 * @param {string} file the function ts file
 */
function processExport(file: string) {
  const functionName: string = camelcase(file.slice(0, -5).split('/').join('_')) // Strip off '.f.ts'
  exports[functionName] = require(file)
}
