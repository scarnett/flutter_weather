#!/bin/bash

set -euo pipefail

zip -r "${{ env.FLUTTER_WEATHER_APK_ZIP_OUTPUT_FILE }}" "${{ env.FLUTTER_WEATHER_APK_OUTPUT_FILE }}"
ls -l "${{ env.FLUTTER_WEATHER_APK_ZIP_OUTPUT_FILE }}"