#!/bin/bash

set -euo pipefail

security import "${{ env.FLUTTER_WEATHER_CERTS_FILE_PATH }}" -k "${{ env.FLUTTER_WEATHER_KEYCHAIN }}" -P "${{ env.FLUTTER_WEATHER_CERTS_PASSWORD }}" -A
security set-key-partition-list -S apple-tool:,apple: -s -k "" "${{ env.FLUTTER_WEATHER_KEYCHAIN }}"
tar xzvf "${{ env.FLUTTER_WEATHER_PROVISION_FILE_PATH }}"
mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
for PROVISION in `ls ./*.mobileprovision`
do
  UUID=`/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i ./$PROVISION)`
  cp "./$PROVISION" "$HOME/Library/MobileDevice/Provisioning Profiles/$UUID.mobileprovision"
done