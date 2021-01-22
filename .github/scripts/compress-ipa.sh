#!/bin/bash

set -euo pipefail

mkdir Payload
cd Payload
ln -s ../Runner.app
cd ..
zip -r "${{ env.FLUTTER_WEATHER_IPA_OUTPUT_FILE }}" Payload
ls -l "${{ env.FLUTTER_WEATHER_IPA_OUTPUT_FILE }}"