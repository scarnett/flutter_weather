#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER"
mkdir Payload
mkdir -p SwiftSupport/iphoneos
cd Payload
ln -s ../Runner.app
cd ..
cp -vr "$XCODE_SWIFT_LIBS" "./SwiftSupport/iphoneos/"
rm "./SwiftSupport/iphoneos/libswiftRemoteMirror.dylib"
find "./SwiftSupport" -name ".DS_Store" -delete

zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload SwiftSupport
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FILE"