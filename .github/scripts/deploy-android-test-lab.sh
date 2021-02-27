#!/bin/bash

set -euo pipefail

# ./gradlew app:assembleAndroidTest
# ./gradlew app:assembleDebug -Ptarget=integration_test/views/lookup/lookup_view_test.dart

# gcloud auth activate-service-account --key-file="$FIREBASE_SERVICE_ACCOUNT_MY_FLUTTER_WEATHER"
gcloud auth activate-service-account --key-file="my-flutter-weather-firebase-adminsdk-et7se-414c9d939d.json"
# gcloud --quiet config set project "$FIREBASE_PROJECT_ID"
gcloud --quiet config set project "my-flutter-weather"
gcloud firebase test android run \
  --type instrumentation \
  --app /home/scott/dev/apps/flutter_weather/apps/mobile_flutter/build/app/outputs/flutter-apk/app-prod-debug.apk \
  --test /home/scott/dev/apps/flutter_weather/apps/mobile_flutter/build/app/outputs/apk/androidTest/prod/debug/app-prod-debug-androidTest.apk \
  --device model=Pixel2,version=29,orientation=portrait \
  --environment-variables package="io.flutter_weather.prod",debug=false \
  --timeout 2m \
  --results-bucket=flutter-weather

# --environment-variables package="$FIREBASE_ANDROID_PACKAGE_NAME",debug=false \
# --results-dir=<RESULTS_DIRECTORY>
