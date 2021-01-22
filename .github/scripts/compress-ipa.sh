#!/bin/bash

set -euo pipefail

mkdir Payload
cd Payload
ln -s ../Runner.app
cd ..
zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER""$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER""$FLUTTER_WEATHER_IPA_OUTPUT_FILE"