#!/bin/bash

set -euo pipefail

flutter build appbundle -t lib/main_prod.dart --flavor prod --release --verbose
