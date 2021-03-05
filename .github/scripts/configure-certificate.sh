#!/bin/bash

set -euo pipefail

# sudo security add-trusted-cert -d -r trustRoot -k "$FLUTTER_WEATHER_KEYCHAIN" "./apps/mobile_flutter/ios/flutterWeather.cer" #TODO! cer path
# security export -k "$FLUTTER_WEATHER_KEYCHAIN" -t all -f pkcs12 -P "$FLUTTER_WEATHER_CERTS_PASSWORD" -o "$FLUTTER_WEATHER_CERTS_FILE_PATH"

echo "$FLUTTER_WEATHER_CERTS_FILE_PATH"
echo "$FLUTTER_WEATHER_KEYCHAIN"
echo "$FLUTTER_WEATHER_CERTS_PASSWORD"
security import "$FLUTTER_WEATHER_CERTS_FILE_PATH" -k "$FLUTTER_WEATHER_KEYCHAIN" -P "$FLUTTER_WEATHER_CERTS_PASSWORD" -A
security find-identity
security set-key-partition-list -S apple-tool:,apple: -s -k "" "$FLUTTER_WEATHER_KEYCHAIN"