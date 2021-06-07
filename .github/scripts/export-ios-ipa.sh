#!/bin/bash

set -euo pipefail

xcodebuild -exportArchive \
  -archivePath "$FLUTTER_WEATHER_XCARCHIVE" \
  -exportOptionsPlist "$FLUTTER_WEATHER_EXPORT_OPTIONS" \
  -exportPath "$FLUTTER_WEATHER_EXPORT_IPA_FILE_PATH"
