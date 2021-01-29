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

    with open('../templates/firebase-remote-config.json', 'r+') as f:
      data = json.load(f)
      data['parameters']['app_version']['conditionalValues'][platform]['value'] = version
      f.seek(0)
      json.dump(data, f)
      f.truncate()
except getopt.error as err:
    print(str(err))
