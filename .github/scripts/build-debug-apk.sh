#!/bin/bash

set -euo pipefail

cd apps/mobile_flutter/android
./gradlew app:assembleAndroidTest
./gradlew app:assembleDebug -Ptarget=/home/scott/dev/apps/flutter_weather/apps/mobile_flutter/integration_test/add_location_test.dart
