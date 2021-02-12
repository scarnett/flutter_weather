#!/bin/bash

set -euo pipefail

gcloud auth activate-service-account --key-file=/home/scott/dev/apps/flutter_weather/.github/scripts/my-flutter-weather-firebase-adminsdk-et7se-99c04b8f4e.json
gcloud --quiet config set project my-flutter-weather
gcloud firebase test android run \
  --type instrumentation \
  --app /home/scott/dev/apps/flutter_weather/apps/mobile_flutter/build/app/outputs/flutter-apk/app.apk \
  --test /home/scott/dev/apps/flutter_weather/apps/mobile_flutter/build/app/outputs/apk/androidTest/prod/debug/app-prod-debug-androidTest.apk \
  --device model=Pixel2,version=29,orientation=portrait \
  --environment-variables package=io.flutter_weather.prod,debug=false \
  --timeout 2m \
  --results-bucket=flutter-weather
# --results-dir=<RESULTS_DIRECTORY>
