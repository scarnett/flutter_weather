#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_IPA_OUTPUT_FOLDER"
mkdir Payload
cd Payload
ln -s ../Runner.app
cd ..

APP="Payload/Runner.app"

DEVELOPER_DIR=`xcode-select --print-path`
if [ ! -d "${DEVELOPER_DIR}" ]; then
  echo "No developer directory found!"
  exit 1
fi

echo "+ Adding SWIFT support (if necessary)"
if [ -d "${APP}/Frameworks" ];
then
    mkdir -p SwiftSupport
    for SWIFT_LIB in $(ls -1 "${APP}/Frameworks/"); do
        echo "Copying ${SWIFT_LIB}"
        cp "${DEVELOPER_DIR}/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/iphoneos/${SWIFT_LIB}" "./SwiftSupport"
    done
fi

zip -r "$FLUTTER_WEATHER_IPA_OUTPUT_FILE" Payload SwiftSupport
ls -l "$FLUTTER_WEATHER_IPA_OUTPUT_FILE"