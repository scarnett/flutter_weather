#!/bin/bash

# set -euo pipefail

cd apps/mobile_flutter/android

pushd android
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=/home/scott/dev/apps/flutter_weather/apps/mobile_flutter/integration_test/views/lookup_view_test.dart
# ./gradlew app:assembleDebug -Ptarget=/home/scott/dev/apps/flutter_weather/apps/mobile_flutter/integration_test/views/lookup_view_test.dart
popd