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

# INstall firebase
npm install -g firebase-tools

# Download the remote configuration template and dump it to a file
firebase remoteconfig:get -o ../templates/firebase-remote-config.json

# Update some values in the file
python update-remote-config.py -p "$platform" -v "$version"

# Deploy the updated remote configuration template
firebase deploy --only remoteconfig