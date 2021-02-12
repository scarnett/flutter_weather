#!/bin/bash

set -euo pipefail

cd apps/mobile_flutter
flutter build apk -t lib/main_prod.dart --flavor prod --release --verbose
