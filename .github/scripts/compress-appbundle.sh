#!/bin/bash

set -euo pipefail

zip -r "$FLUTTER_WEATHER_APPBUNDLE_ZIP_OUTPUT_FILE" "$FLUTTER_WEATHER_APPBUNDLE_OUTPUT_FILE"
ls -l "$FLUTTER_WEATHER_APPBUNDLE_ZIP_OUTPUT_FILE"