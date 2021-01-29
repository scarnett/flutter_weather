#!/bin/bash

set -euo pipefail

while getopts ":p:v:" opt; do
  case $opt in
    p) platform="$OPTARG"
    ;;
    v) version="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Update some values in the file
python .github/scripts/update-remote-config.py -p "$platform" -v "$version"