import argparse, requests, os, time, json, base64, errno
from authlib.jose import jwt


def parse_options():
    '''
    Parses the program options
    '''

    parser = argparse.ArgumentParser()
    parser.add_argument('--homePath')
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

    try:
        url = 'https://api.appstoreconnect.apple.com/v1/devices'
        response = requests.get(url, headers=http_headers(token))
        jsonData = response.json()
        if 'data' in jsonData:
            devices = []

            for device in jsonData['data']:
                devices.append({
                    'type': 'devices',
                    'id': device['id']
                })
            return devices
        else:
            print('get_devices bad response: {}'.format(jsonData))
    except Exception as e:
        print('get_devices error: {}'.format(e))
    return []


def find_profile(token):
    '''
    Finds a provisioning profile by its name

    Args:
        token (string): The JWT token
    '''

    try:
        url = 'https://api.appstoreconnect.apple.com/v1/profiles'
        response = requests.get(url, params={'filter[name]': args.profileName}, headers=http_headers(token))
        jsonData = response.json()
        if 'data' in jsonData:
            return jsonData['data'][0]
        else:
            print('find_profile bad response: {}'.format(jsonData))
    except Exception as e:
        print('find_profile error: {}'.format(e))
    return None


def delete_profile(token, profileId):
    '''
    Deletes a provisioning profile

    Args:
        token (string): The JWT token
        profileId (string): The profile id
    '''

    try:
        url = 'https://api.appstoreconnect.apple.com/v1/profiles/{}'.format(profileId)
        requests.delete(url, headers=http_headers(token))
        return True
    except Exception as e:
        print('delete_profile error: {}'.format(e))
    return False


def create_profile(token):
    '''
    Creates a new provisioning profile using the team devices

    Args:
        token (string): The JWT token
   '''

    try:
        url = 'https://api.appstoreconnect.apple.com/v1/profiles'
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
                    }
                }
            }
        }

        # Add devices to the ad hoc provisioning profile
        if args.profileType == 'IOS_APP_ADHOC':
            data['data']['relationships']['devices'] = {
                'data': get_devices(token)
            }

        response = requests.post(url, json.dumps(data), headers=http_headers(token))
        jsonData = response.json()
        if 'data' in jsonData:
            profile = jsonData['data']

            # Write the provisioning profile content to a file
            filePath = '{}/Library/MobileDevice/Provisioning Profiles/profile.mobileprovision'.format(args.homePath)
            makeFile(filePath)
            with open(filePath, 'w+') as provisionFile:
                provisionFile.write(base64.b64decode(profile['attributes']['profileContent']))

            return profile
        else:
            print('create_profile bad response: {}'.format(jsonData))
    except Exception as e:
        print('create_profile error: {}'.format(e))
    return None


def download_certificate(token, profileId):
    '''
    Downloads the certificate for a provisioning profile

    Args:
        token (string): The JWT token
        profileId (string): The profile id
    '''

    try:
        url = 'https://api.appstoreconnect.apple.com/v1/profiles/{}/certificates'.format(profileId)
        response = requests.get(url, headers=http_headers(token))
        jsonData = response.json()
        if 'data' in jsonData:
            certificates = jsonData['data']

            # Write the certificate content to a file
            filePath = './apps/mobile_flutter/ios/flutterWeather.cer' #TODO! cer path
            makeFile(filePath)
            with open(filePath, 'w+') as cerFile:
                cerFile.write(base64.b64decode(certificates[0]['attributes']['certificateContent']))

            return certificates[0]
        else:
            print('download_certificate bad response: {}'.format(jsonData))
    except Exception as e:
        print('download_certificate error: {}'.format(e))
    return None


def makeFile(fileName):
    '''
    Creates a file and its parent folders if they don't already exist
    '''

    if not os.path.exists(os.path.dirname(fileName)):
        try:
            os.makedirs(os.path.dirname(fileName))
        except OSError as e:
            if e.errno != errno.EEXIST:
                raise


def letsDoThis():
    '''
    This kicks off the process of installing the provisioning profile
    and downloading the certificate.
    '''

    try:
        # Generate a new JWT token
        token = get_token().decode('UTF-8')
        if token:
            print('jwt token created')

            # Ad Hoc
            if args.profileType == 'IOS_APP_ADHOC':
                # Find the existing provisioning profile if it exists
                oldProfile = find_profile(token)
                if oldProfile:
                    print('old profile found. deleting...')

                    # Delete the provisioning profile
                    if delete_profile(token, oldProfile['id']):
                        print('old profile deleted')
                    else:
                        print('failed to delete old profile')

                # Create a new provisioning profile
                print('creating new profile...')
                newProfile = create_profile(token)
                if newProfile:
                    print('new profile created')
                    print('downloading certificate')

                    certificate = download_certificate(token, newProfile['id'])
                    if certificate:
                        print('certificate downloaded')
                    else:
                        print('failed to download certificate')
            # Distribution
            elif args.profileType == 'IOS_APP_STORE':
                profile = find_profile(token)
                if profile:
                    print('profile found')

                    certificate = download_certificate(token, profile['id'])
                    if certificate:
                        print('certificate downloaded')
                    else:
                        print('failed to download certificate')
        else:
            print('failed to create jwt token')
    except Exception as err:
        print(str(err))


# Parse the options
args = parse_options()

# Do it
letsDoThis()
