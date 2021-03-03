import getopt, sys, requests, time, json
from authlib.jose import jwt

keyId = None            # https://appstoreconnect.apple.com/access/api
issuerId = None         # https://appstoreconnect.apple.com/access/api
privateKey = None       # p8 file
identifier = None       # https://developer.apple.com/account/resources/identifiers/bundleId/edit/<identifier>
certificateId = None    # https://developer.apple.com/account/resources/certificates/download/<certificateId>
profileName = None
profileType = None
expirationDate = int(round(time.time() + (20.0 * 60.0))) # 20 minutes timestamp


def parse_options():
    options = ['keyId', 'issuerId', 'privateKey', 'identifier', 'certificateId', 'profileName', 'profileType']
    arguments, values = getopt.getopt(sys.argv[1:], '', options)
    for currentArgument, currentValue in arguments:
        if currentArgument in ('--keyId'):
            keyId = currentValue
        elif currentArgument in ('--issuerId'):
            issuerId = currentValue
        elif currentArgument in ('--privateKey'):
            privateKey = currentValue
        elif currentArgument in ('--identifier'):
            identifier = currentValue
        elif currentArgument in ('--certificateId'):
            certificateId = currentValue
        elif currentArgument in ('--profileName'):
            profileName = currentValue
        elif currentArgument in ('--profileType'):
            profileType = currentValue


def get_token():
    '''
    Generates the apple connect JWT token

    Returns:
        token: A JWT token
    '''

    header = {
        'alg': 'ES256',
        'kid': keyId,
        'typ': 'JWT'
    }

    payload = {
        'iss': issuerId,
        'exp': expirationDate,
        'aud': 'appstoreconnect-v1'
    }

    return jwt.encode(header, payload, privateKey)


def http_headers(token):
    '''
    Builds the apple connect api headers

    Args:
        token (string): The JWT token
    '''

    HEAD = {
        'Authorization': 'Bearer ' + token,
        'Content-Type': 'application/json'
    }

    return HEAD


def get_devices(token):
    '''
    Gets a list of devices

    Args:
        token (string): The JWT token
    '''

    URL = 'https://api.appstoreconnect.apple.com/v1/devices'

    try:
        response = requests.get(URL, headers=http_headers(token))
        data = response.json()['data']
        devices = []

        for device in data:
            devices.append({
                'type': 'devices',
                'id': device['id']
            })
        return devices
    except BaseException as e:
        print(e)
        return []


def register_profile(token):
    '''
    Registers a new provisioning profile using the team devices

    Args:
        token (string): The JWT token
   '''

    URL = 'https://api.appstoreconnect.apple.com/v1/profiles'

    data = {
        'data': {
            'type': 'profiles',
            'attributes': {
                'name': profileName,
                'profileType': profileType
            },
            'relationships': {
                'bundleId': {
                    'data': {
                        'type': 'bundleIds',
                        'id': identifier
                    }
                },
                'certificates': {
                    'data': [{         
                        'type': 'certificates',
                        'id': certificateId
                    }]
                },
                'devices': {
                    'data': get_devices(token)
                }
            }
        }
    }

    try:
        response = requests.post(URL, json.dumps(data), headers=http_headers(token))
        # print(response.json())
    except BaseException as e:
        print(e)

# Parse the options
parse_options()

# Generate a new JWT token
token = get_token().decode('UTF-8')

# Create the provisioning profile
register_profile(token)
