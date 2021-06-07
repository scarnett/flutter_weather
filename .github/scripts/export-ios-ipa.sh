#!/bin/bash

set -euo pipefail

xcodebuild -exportArchive \
  -archivePath "$FLUTTER_WEATHER_EXPORT_XCARCHIVE_FILE_PATH" \
  -exportOptionsPlist "$FLUTTER_WEATHER_EXPORT_OPTIONS_PLIST_FILE_PATH" \
  -exportPath "$FLUTTER_WEATHER_EXPORT_IPA_FILE_PATH$FLUTTER_WEATHER_EXPORT_IPA_FILE_NAME"
