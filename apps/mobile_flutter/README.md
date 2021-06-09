<p align="center">
  <img src="../../docs/images/logo.png" alt="Flutter Weather" width="200" />
</p>

<h1 align="center">Flutter Weather</h1>
<p align="center">A beautiful weather forecasting application built with the <a href="https://www.flutter.dev/" target="_blank">Flutter development kit</a>.</p>

<p align="center">
<a href="https://play.google.com/store/apps/details?id=io.flutter_weather.prod" target="_blank"><img src="../../docs/images/play_store.png" height="50" /></a>&nbsp;&nbsp;&nbsp;<a href="https://apps.apple.com/us/app/my-flutter-weather/id1550322379" target="_blank"><img src="../../docs/images/app_store.png"  height="50" /></a>
</p>

<h2 align="center">Screenshots</h2>
<table cellspacing="0" style="width:100%">
  <tbody>
    <tr>
      <td style="text-align:right"><img src="../../docs/images/screen1.png" alt="Flutter Weather" style="max-height:500px" /></td>
      <td style="text-align:center"><img src="../../docs/images/screen2.png" alt="Flutter Weather" style="max-height:500px" /></td>
      <td style="text-align:left"><img src="../../docs/images/screen3.png" alt="Flutter Weather" style="max-height:500px" /></td>
    </tr>
  </tbody>
</table>

## Firebase Remote Configuration

| Name                                     | Value                                                                | Optional |
|------------------------------------------|----------------------------------------------------------------------|----------|
| app_version                              | 1.0.0                                                                | No       |
| app_build                                | 123                                                                  | No       |
| app_connectivity_status                  | https://<firebase_project_id>.web.app/http-connectivity-status       | No       |
| app_push_notifications_remove            | https://<firebase_project_id>.web.app/http-push-notifications-remove | No       |
| app_push_notifications_save              | https://<firebase_project_id>.web.app/http-push-notifications-save   | No       |
| openweathermap_api_key                   | <your_openweather_api_key>                                           | No       |
| openweathermap_api_uri                   | api.openweathermap.com                                               | No       |
| openweathermap_api_daily_forecast_path   | /data/2.5/forecast/daily                                             | No       |
| openweathermap_api_one_call_path         | /data/2.5/onecall                                                    | No       |
| openweathermap_api_current_forecast_path | /data/2.5/weather                                                    | No       |
| refresh_timeout                          | 300000                                                               | No       |
| default_country_code                     | us                                                                   | No       |
| supported_locales                        | en                                                                   | No       |
| privacy_policy_url                       |                                                                      | Yes      |
| github_url                               |                                                                      | Yes      |
| sentry_dsn                               | <your_sentry_dsn>                                                    | Yes      |

## Android Configuration

Create a file called **local.properties** in the **android** folder with the following:
```bash
sdk.dir=<path_to_android_sdk>
flutter.sdk=<path_to_flutter_sdk>
flutter.appLabel=Flutter Weather
flutter.buildMode=<debug|profile|release>
flutter.versionName=1.0.0
```

Create a file called **key.properties** in the **android** folder with the following:
```bash
storePassword=
keyPassword=
keyAlias=
storeFile=
```

## Firebase Configuration

This application uses <a href="https://firebase.google.com/" target="_blank">Firebase</a> for web hosting, app distribution, functions and remote configuration. You will need to create your own account and copy your Firebase configuration into the following folder(s):

**Android**:
```bash
android/app/google-services.json
```

**iOS**:
```bash
ios/Runner/GoogleService-Info.plist
```

You can find this file in your Firebase console in *Project Settings -> Your apps -> SDK setup and configuration*.

## Firebase Functions
```bash
nx run firebase:deploy-functions
```
[**Read More**](../firebase/README.md)

## Firebase Firestore Rules
```bash
nx run firebase:deploy-firestore-rules
```
[**Read More**](../firebase/README.md)

## Firebase Hosting
```bash
nx run firebase:deploy-hosting
```
[**Read More**](../firebase/README.md)

## Run Application (Nx)
This project uses <a href="https://nx.dev" target="_blank">Nx</a>. Go [here](https://nx.dev/latest/angular/getting-started/cli-overview) for installation instructions.

**DEV**
```bash
nx run mobile_flutter:runDev
```

**PROD**
```bash
nx run mobile_flutter:runProd
```

## Run Application (Docker)

**DEV**
```bash
docker-compose up flutter_weather_dev
```

**PROD**
```bash
docker-compose up flutter_weather_prod
```

## Build Android
**APK**
```bash
nx run mobile_flutter:buildApk
```

**Appbundle**
```bash
nx run mobile_flutter:buildAppbundle
```

## Build iOS
```bash
nx run mobile_flutter:buildIos
```

## Build launcher icons

```bash
nx run mobile_flutter:buildLauncherIcons
```

## Build splash screens

```bash
nx run mobile_flutter:buildSplashScreens
```

## Generate mocks
```bash
nx run mobile_flutter:generateMocks
```

## Unit and Widget Tests
```bash
nx run mobile_flutter:test
```

## Integration Tests
```
nx run mobile_flutter:drive --test=views/lookup/lookup_view_test.dart
```

## Credits
Created by [@scarnett](https://github.com/scarnett/)

## License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
Copyright &copy; 2021 Scott Carnett. Licensed under the MIT License (MIT)
