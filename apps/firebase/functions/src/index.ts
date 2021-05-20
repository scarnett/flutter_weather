import camelcase from 'camelcase'
import * as admin from 'firebase-admin'
import * as glob from 'glob'
import * as i18n from 'i18n'
import * as path from 'path'

admin.initializeApp()

const paths: string[] = [
  './firestore/**/*.f.js', // Firestore
  './http/**/*.f.js', // HTTP
  './schedule/*.f.js', // Cron
]

i18n.configure({
  locales: ['en'],
  directory: path.join(__dirname, 'locales'),
})

for (const filePath of paths) {
  const files: string[] = glob.sync(filePath, {cwd: __dirname, ignore: `./node_modules/**`})
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
