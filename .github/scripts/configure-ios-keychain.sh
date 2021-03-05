#!/bin/bash

set -euo pipefail

security create-keychain -p "" "$FLUTTER_WEATHER_KEYCHAIN"
security list-keychains -s "$FLUTTER_WEATHER_KEYCHAIN"
security default-keychain -s "$FLUTTER_WEATHER_KEYCHAIN"
security unlock-keychain -p "" "$FLUTTER_WEATHER_KEYCHAIN"
security set-keychain-settings
security list-keychains
