#!/bin/bash

set -euo pipefail

security import "$FLUTTER_WEATHER_CERTS_FILE_PATH" -k "$FLUTTER_WEATHER_KEYCHAIN" -P "$FLUTTER_WEATHER_CERTS_P12_PASSWORD" -A
security find-identity
security set-key-partition-list -S apple-tool:,apple: -s -k "" "$FLUTTER_WEATHER_KEYCHAIN"