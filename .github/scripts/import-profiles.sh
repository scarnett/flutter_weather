#!/bin/bash

set -euo pipefail

security import "$FLUTTER_WEATHER_CERTS_FILE_PATH" -k "$FLUTTER_WEATHER_KEYCHAIN" -P "$FLUTTER_WEATHER_CERTS_PASSWORD" -A
security set-key-partition-list -S apple-tool:,apple: -s -k "" "$FLUTTER_WEATHER_KEYCHAIN"
mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
echo "$1" > "$HOME/Library/MobileDevice/Provisioning Profiles/profile.mobileprovision"