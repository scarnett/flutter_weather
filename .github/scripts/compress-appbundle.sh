#!/bin/bash

set -euo pipefail

cd "$FLUTTER_WEATHER_RELEASE_FOLDER"
zip -r "$FLUTTER_WEATHER_RELEASE_ZIP" "$FLUTTER_WEATHER_RELEASE_APP"
ls -l "$FLUTTER_WEATHER_RELEASE_ZIP"