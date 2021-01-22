#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER"
mkdir Payload
mkdir SwiftSupport
cd Payload
ln -s ../Runner.app
cd ..
zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FILE"