#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER"
mkdir Payload
mkdir -p SwiftSupport/iphoneos

cd Payload
ln -s ../Runner.app
cd ..

for FRAMEWORK in `ls ./Payload/Runner.app/Frameworks/*.framework`
do
  echo "$FRAMEWORK"
  cp "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/$FRAMEWORK" "./SwiftSupport/iphoneos/$FRAMEWORK"
done

zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload SwiftSupport
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FILE"