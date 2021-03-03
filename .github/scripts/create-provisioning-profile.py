import argparse, requests, time, json, base64
from authlib.jose import jwt


def parse_options():
    '''
    Parses the program options
    '''

    parser = argparse.ArgumentParser()
    parser.add_argument('--keyId')
    parser.add_argument('--issuerId')
    parser.add_argument('--privateKey')
    parser.add_argument('--identifier')
    parser.add_argument('--certificateId')
    parser.add_argument('--certificatePath')
    parser.add_argument('--profileName')
    parser.add_argument('--profileType')
    return parser.parse_args()


def get_token():
    '''
    Generates the apple connect JWT token

    Returns:
        token: A JWT token
    '''

    header = {
        'alg': 'ES256',
        'kid': args.keyId,
        'typ': 'JWT'
    }

    payload = {
        'iss': args.issuerId,
        'exp': int(round(time.time() + (20.0 * 60.0))), # 20 minutes timestamp
        'aud': 'appstoreconnect-v1'
    }

    return jwt.encode(header, payload, args.privateKey)


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
    except Exception as e:
        print(e)
        return []


def download_certificate(token):
    URL = 'https://api.appstoreconnect.apple.com/v1/certificates/{}'.format(args.certificateId) 
    response = requests.get(URL, headers=http_headers(token))

    try:
        with open('./flutterWeather.cer', 'w') as text_file:
            json = response.json()
            if 'data' in json:
                text_file.write(base64.b64decode(response.json()['data']['attributes']['certificateContent']))
    except Exception as e:
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
                'name': args.profileName,
                'profileType': args.profileType
            },
            'relationships': {
                'bundleId': {
                    'data': {
                        'type': 'bundleIds',
                        'id': args.identifier
                    }
                },
                'certificates': {
                    'data': [{         
                        'type': 'certificates',
                        'id': args.certificateId
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
    except Exception as e:
        print(e)

try:
    # Parse the options
    args = parse_options()

    # Generate a new JWT token
    token = get_token().decode('UTF-8')

    # Create the provisioning profile
    register_profile(token)

    download_certificate(token)
except Exception as err:
    print(str(err))