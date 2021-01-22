#!/bin/bash

set -euo pipefail

security create-keychain -p "" "${{ env.FLUTTER_WEATHER_KEYCHAIN }}"
security list-keychains -s "${{ env.FLUTTER_WEATHER_KEYCHAIN }}"
security default-keychain -s "${{ env.FLUTTER_WEATHER_KEYCHAIN }}"
security unlock-keychain -p "" "${{ env.FLUTTER_WEATHER_KEYCHAIN }}"
security set-keychain-settings
security list-keychains