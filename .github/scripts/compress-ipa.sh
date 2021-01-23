#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER"
mkdir Payload
mkdir -p SwiftSupport/iphoneos
cd Payload
ln -s ../Runner.app
cd ..
cp -vr "$XCODE_SWIFT_PREBUILT_MODULES" "./SwiftSupport/iphoneos/"

zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload SwiftSupport
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FILE"