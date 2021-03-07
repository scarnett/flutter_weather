#!/bin/bash

set -euo pipefail

# gcloud auth activate-service-account --key-file="$FIREBASE_SERVICE_ACCOUNT_MY_FLUTTER_WEATHER"
gcloud auth activate-service-account --key-file="my-flutter-weather-firebase-adminsdk-et7se-414c9d939d.json"
# gcloud --quiet config set project "$FIREBASE_PROJECT_ID"
gcloud --quiet config set project "my-flutter-weather"
gcloud firebase test android run \
  --type instrumentation \
  --app /home/scott/dev/apps/flutter_weather/apps/mobile_flutter/build/app/outputs/apk/tst/debug/app-tst-debug.apk \
  --test /home/scott/dev/apps/flutter_weather/apps/mobile_flutter/build/app/outputs/apk/androidTest/tst/debug/app-tst-debug-androidTest.apk \
  --device model=jeter,version=26,orientation=portrait \
  --environment-variables package="io.flutter_weather.prod",debug=false \
  --timeout 5m \
  --results-bucket=flutter-weather

# --environment-variables package="$FIREBASE_ANDROID_PACKAGE_NAME",debug=false \
# --results-dir=<RESULTS_DIRECTORY>
