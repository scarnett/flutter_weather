#!/bin/bash

set -euo pipefail

security create-keychain -p "" "$FLUTTER_WEATHER_KEYCHAIN"
security list-keychains -s "$FLUTTER_WEATHER_KEYCHAIN"
security default-keychain -s "$FLUTTER_WEATHER_KEYCHAIN"
security unlock-keychain -p "" "$FLUTTER_WEATHER_KEYCHAIN"
security set-keychain-settings
security list-keychains

sudo security add-trusted-cert -d -r trustRoot -k "$FLUTTER_WEATHER_KEYCHAIN" "./flutterWeather.cer"
# security export -k "$FLUTTER_WEATHER_KEYCHAIN" -t all -f pkcs12 -P "$FLUTTER_WEATHER_CERTS_PASSWORD" -o "$FLUTTER_WEATHER_CERTS_FILE_PATH"