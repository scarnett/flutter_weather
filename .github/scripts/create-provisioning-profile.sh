#!/bin/bash

set -euo pipefail

# Create a virtual environment for python
pip install virtualenv
python -m virtualenv env
source env/bin/activate

# Install libs
pip install requests Authlib

# Create the provisioning profile
python .github/scripts/create-provisioning-profile.py \
  -keyId "$FLUTTER_WEATHER_APPSTORE_KEY_ID" \
  -issuerId "$FLUTTER_WEATHER_APPSTORE_ISSUER_ID" \
  -privateKey "$FLUTTER_WEATHER_APPSTORE_PRIVATE_KEY" \
  -identifier "$FLUTTER_WEATHER_APPSTORE_IDENTIFIER" \
  -certificateId "$FLUTTER_WEATHER_APPSTORE_CERTIFICATE_ID" \
  -profileName "$FLUTTER_WEATHER_APPSTORE_PROFILE_NAME" \
  -profileType "$FLUTTER_WEATHER_APPSTORE_PROFILE_TYPE"
