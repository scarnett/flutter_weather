#!/bin/bash

set -euo pipefail

gcloud auth activate-service-account --key-file="$FIREBASE_SERVICE_ACCOUNT_MY_FLUTTER_WEATHER"
gcloud --quiet config set project "$FIREBASE_PROJECT_ID"
gcloud firebase test android run \
  --type instrumentation \
  --app ./apps/mobile_flutter/build/app/outputs/flutter-apk/app.apk \
  --test ./apps/mobile_flutter/build/app/outputs/apk/androidTest/prod/debug/app-prod-debug-androidTest.apk \
  --device model=Pixel2,version=29,orientation=portrait \
  --environment-variables package="$FIREBASE_ANDROID_PACKAGE_NAME",debug=false \
  --timeout 2m \
  --results-bucket=flutter-weather
# --results-dir=<RESULTS_DIRECTORY>
