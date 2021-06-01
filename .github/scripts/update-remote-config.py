#!/usr/bin/python3

import getopt, sys, json

argumentList = sys.argv[1:]
options = 'p:v:'
long_options = ['platform', 'version']
platform = None
version = None

try:
    arguments, values = getopt.getopt(argumentList, options, long_options)
    for currentArgument, currentValue in arguments:
        if currentArgument in ('-p', '--platform'):
            platform = currentValue
        elif currentArgument in ('-v', '--version'):
            version = currentValue

    with open('firebase-remote-config.json', 'r+') as f:
      data = json.load(f)
      version_build_parts = version.split('+')
      data['parameters']['app_version']['defaultValue']['value'] = version_build_parts[0]
      data['parameters']['app_build']['defaultValue']['value'] = version_build_parts[1]

      # Example of using the device platform
      # data['parameters']['app_version']['conditionalValues'][platform]['value'] = version_build_parts[0]
      # data['parameters']['app_build']['conditionalValues'][platform]['value'] = version_build_parts[1]

      f.seek(0)
      json.dump(data, f)
      f.truncate()
except getopt.error as err:
    print(str(err))
