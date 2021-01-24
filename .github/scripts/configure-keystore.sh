#!/bin/bash

set -euo pipefail

echo "$FLUTTER_WEATHER_KEYSTORE" > apps/mobile_flutter/android/app/key.jks.asc
gpg -d --passphrase "$FLUTTER_WEATHER_KEYSTORE_PASS" --batch apps/mobile_flutter/android/app/key.jks.asc > apps/mobile_flutter/android/app/key.jks