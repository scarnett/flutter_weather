#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER"
mkdir Payload
mkdir -p SwiftSupport/iphoneos

for FRAMEWORK in `ls ./Payload/Runner.app/Frameworks/*.framework`
do
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/$FRAMEWORK" "./SwiftSupport/iphoneos/$FRAMEWORK"
done

cd Payload
ln -s ../Runner.app
cd ..
zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload SwiftSupport
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FILE"