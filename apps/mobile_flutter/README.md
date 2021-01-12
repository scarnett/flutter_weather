<p align="center">
  <img src="../../docs/images/logo.png" width="200" alt="Flutter Weather" />
</p>

<h1 align="center">Flutter Weather</h1>
<p align="center">A beautiful weather forecasting application built with the <a href="https://www.flutter.dev/" target="_blank">Flutter development kit</a>.</p>

## Screenshots
|<div align="center">Colorized</div>|<div align="center">Light</div>|<div align="center">Dark</div>|
|---------|-----|----|
|<span align="center"><img src="docs/images/screen1.png" width="300" alt="Flutter Weather" /></span>|<span align="center"><img src="docs/images/screen2.png" width="300" alt="Flutter Weather" /></span>|<span align="center"><img src="docs/images/screen3.png" width="300" alt="Flutter Weather" /></span>|

## Environment Configuration
You will need to create a file called **env_config.dart** in the **lib** folder with the following:

```dart
class EnvConfig {
  static const String OPENWEATHERMAP_API_KEY = '<your_openweather_api_key>';
  static const String OPENWEATHERMAP_API_URI = 'api.openweathermap.org';
  static const String OPENWEATHERMAP_API_DAILY_PATH = '/data/2.5/forecast/daily';
  static const int REFRESH_TIMEOUT_MINS = 5;
  static const String DEFAULT_COUNTRY_CODE = 'us';
  static const String SUPPORTED_LOCALES = 'en';
  static const String LATEST_VERSION = '1.0.0';
  static const String PRIVACY_POLICY_URL = '<your_privacy_policy_url>';
}

```

## Android Configuration
You will need to reate a file called **local.properties** in the **android** folder with the following:
```bash
sdk.dir=<path_to_android_sdk>
flutter.sdk=<path_to_flutter_sdk>
flutter.buildMode=<debug|profile|release>
flutter.versionName=1.0.0
```

## Run Application (Nx)

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

## Credits
Created by [@scarnett](https://github.com/scarnett/)