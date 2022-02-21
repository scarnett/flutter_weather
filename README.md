<p align="center">
  <img src="docs/images/logo.png" alt="Flutter Weather" width="200" />
</p>

<h1 align="center">Flutter Weather</h1>
<p align="center">A beautiful weather forecasting application built with the <a href="https://www.flutter.dev/" target="_blank">Flutter development kit</a>.</p>

<p align="center">
<a href="https://play.google.com/store/apps/details?id=io.flutter_weather.prod" target="_blank"><img src="docs/images/play_store.png" height="50" /></a>&nbsp;&nbsp;&nbsp;<a href="https://apps.apple.com/us/app/my-flutter-weather/id1550322379" target="_blank"><img src="docs/images/app_store.png"  height="50" /></a>
</p>

<h2 align="center">Screenshots</h2>
<table cellspacing="0" style="width:100%">
  <tbody>
    <tr>
      <td style="text-align:right"><img src="docs/images/screen1.png" alt="Flutter Weather" style="max-height:500px" /></td>
      <td style="text-align:center"><img src="docs/images/screen2.png" alt="Flutter Weather" style="max-height:500px" /></td>
      <td style="text-align:left"><img src="docs/images/screen3.png" alt="Flutter Weather" style="max-height:500px" /></td>
    </tr>
  </tbody>
</table>

## Analysis
[![Deploy Release to App Stores](https://github.com/scarnett/flutter_weather/actions/workflows/deploy-release.yml/badge.svg)](https://github.com/scarnett/flutter_weather/actions/workflows/deploy-release.yml)
[![Bugs](https://sonarcloud.io/api/project_badges/measure?project=scarnett_flutter_weather&metric=bugs)](https://sonarcloud.io/dashboard?id=scarnett_flutter_weather)
[![Sonarcloud Status](https://sonarcloud.io/api/project_badges/measure?project=scarnett_flutter_weather&metric=alert_status)](https://sonarcloud.io/dashboard?id=scarnett_flutter_weather)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=scarnett_flutter_weather&metric=sqale_rating)](https://sonarcloud.io/dashboard?id=scarnett_flutter_weather)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=scarnett_flutter_weather&metric=alert_status)](https://sonarcloud.io/dashboard?id=scarnett_flutter_weather)

## Run Application
This project uses <a href="https://nx.dev" target="_blank">Nx</a>. Go [here](https://nx.dev/latest/angular/getting-started/cli-overview) for installation instructions.

### Flutter

**DEV**
```bash
nx run mobile_flutter:runDev
```

**PROD**
```bash
nx run mobile_flutter:runProd
```
[**Read More**](apps/mobile_flutter/README.md)

### Firebase Functions
```bash
nx run firebase-functions:deploy
```
[**Read More**](apps/firebase/README.md)

### Firebase Firestore Rules
```bash
nx run firebase-rules:deploy
```
[**Read More**](apps/firebase/README.md)

### Angular
```bash
nx run web_ng:serve
```
[**Read More**](apps/web_ng/README.md)

## Contributing
Pull requests are welcome. For significant changes, please open an issue first to discuss what you would like to change.

Don't feel like contributing to the code? Feature requests, feedback and suggestions are welcome. Reach me via Discord/Slack/email, or create a new issue.

## Credits
Created by [@scarnett](https://github.com/scarnett/)

## License
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  
Copyright &copy; 2021 Scott Carnett. Licensed under the MIT License (MIT)

## Nx
<p>This project was generated using <a href="https://nx.dev" target="_blank">Nx</a>.</p>
<img src="https://raw.githubusercontent.com/nrwl/nx/master/images/nx-logo.png" width="100" />
