import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(
    this.locale,
  );

  static AppLocalizations? of(
    BuildContext context,
  ) =>
      Localizations.of<AppLocalizations>(
        context,
        AppLocalizations,
      );

  static String get appTitle => 'Flutter Weather';

  String get application => addMessage('Application');
  String get settings => addMessage('Settings');
  String get buildInformation => addMessage('Build Information');
  String get about => addMessage('About');
  String get privacyPolicy => addMessage('Privacy Policy');
  String get latest => addMessage('Latest');
  String get updateAvailable => addMessage('Update Available');
  String get updateNow => addMessage('Update Now');
  String get later => addMessage('Later');
  String get beta => addMessage('Beta');
  String get autoUpdates => addMessage('Auto Updates');
  String get updatePeriod => addMessage('Update Period');
  String get updatePeriod1hr => addMessage('1 hour');
  String get updatePeriod2hr => addMessage('2 hours');
  String get updatePeriod3hr => addMessage('3 hours');
  String get updatePeriod4hr => addMessage('4 hours');
  String get updatePeriod5hr => addMessage('5 hours');
  String get updatePeriodUpdated =>
      addMessage('Your update period settings were updated');

  String get pushNotification => addMessage('Push Notification');
  String get pushNotificationOff => addMessage('Off');
  String get pushNotificationSaved => addMessage('Saved Locations');
  String get pushNotificationCurrent => addMessage('Current Location');
  String get pushNotificationCurrentTap => addMessage('Tap to update');
  String get pushNotificationUpdated =>
      addMessage('Your push notification settings were updated');

  String get themeMode => addMessage('Theme Mode');
  String get light => addMessage('Light');
  String get dark => addMessage('Dark');
  String get colorized => addMessage('Colorized');
  String get units => addMessage('Units');
  String get temperature => addMessage('Temperature');
  String get temperatureUnits => addMessage('Temperature Units');
  String get kelvin => addMessage('Kelvin');
  String get celsius => addMessage('Celsius');
  String get fahrenheit => addMessage('Fahrenheit');
  String get hi => addMessage('Hi');
  String get low => addMessage('Low');
  String get wind => addMessage('Wind');
  String get windSpeed => addMessage('Wind Speed');
  String get windSpeedUnits => addMessage('Wind Speed Units');
  String get speedMph => addMessage('mph');
  String get speedKmh => addMessage('km/h');
  String get speedMs => addMessage('m/s');
  String get pressure => addMessage('Pressure');
  String get pressureUnits => addMessage('Pressure Units');
  String get pressureHpa => addMessage('hPa');
  String get pressureInhg => addMessage('inHg');
  String get humidity => addMessage('Humidity');
  String get visibility => addMessage('Visibility');
  String get dewPoint => addMessage('Dew Point');
  String get uvIndex => addMessage('UV Index');
  String get distance => addMessage('Distance');
  String get distanceUnits => addMessage('Distance Units');
  String get distanceMi => addMessage('mi');
  String get distanceKm => addMessage('km');
  String get forecast => addMessage('Forecast');
  String get addForecast => addMessage('Add Forecast');
  String get addThisForecast => addMessage('Add This Forecast');
  String get editForecast => addMessage('Edit Forecast');
  String get deleteForecast => addMessage('Delete Forecast');
  String get refreshForecast => addMessage('Refresh Forecast');
  String get refreshFailure => addMessage(
      'There was an error refreshing this forecast. Please try again.');

  String get locationFailure => addMessage(
      'There was an error getting your current location. Please try again.');

  String get forecastAdded => addMessage('Forecast Added');
  String get forecastUpdated => addMessage('Forecast Updated');
  String get forecastDeleted => addMessage('Forecast Deleted');
  String get forecastDeletedText =>
      addMessage('Are you sure you want to delete this forecast?');

  String get forecastBadForecastInput =>
      addMessage('Please enter the city or postal code');

  String get forecastAlreadyExists => addMessage('Forecast already exists');
  String get forecastCityAlreadyExists =>
      addMessage('A forecast for this city already exists.');

  String get forecastPostalCodeAlreadyExists =>
      addMessage('A forecast for this postal code already exists');

  String get colorThemeEnable => addMessage('Enable Color Theme');
  String get colorThemeDisable => addMessage('Disable Color Theme');
  String get noForecasts => addMessage('No Forecasts Found');
  String get city => addMessage('City');
  String get postalCode => addMessage('Postal Code');
  String get country => addMessage('Country');
  String get primaryForecast => addMessage('Primary Forecast');
  String get save => addMessage('Save');
  String get delete => addMessage('Delete');
  String get cancel => addMessage('Cancel');
  String get yes => addMessage('Yes');
  String get no => addMessage('No');
  String get lookup => addMessage('Lookup');
  String get lookupSuccess => addMessage('Forecast added successfully!');
  String get lookupFailure => addMessage(
      'There was an error looking up this forecast. Please try again.');

  String get selectCountry => addMessage('Select a country');
  String get filterCountries => addMessage('Filter Countries');
  String get locationPermissionDenied =>
      addMessage('Location permission denied');

  String get chartType => addMessage('Chart Type');
  String get chartLine => addMessage('Line');
  String get chartBar => addMessage('Bar');
  String get hourRange => addMessage('Hour Range');
  String get hours12 => addMessage('12hr');
  String get hours24 => addMessage('24hr');
  String get hours36 => addMessage('36hr');
  String get hours48 => addMessage('48hr');

  String getFeelsLike(
    String temp,
  ) =>
      addMessage(
        'Feels like $temp',
        name: 'getFeelsLike',
        args: [temp],
      );

  String getLastUpdatedAt(
    String date,
  ) =>
      addMessage(
        'Last updated at $date',
        name: 'getLastUpdatedAt',
        args: [date],
      );

  String getLastUpdatedOn(
    String date,
  ) =>
      addMessage(
        'Last updated on $date',
        name: 'getLastUpdatedOn',
        args: [date],
      );

  String getUpdateAvailableText(
    String appTitle,
    String packageVersion,
    String appVersion,
  ) =>
      addMessage(
        'Version $appVersion of $appTitle is now available. You\'re ' +
            'currently using version $packageVersion.',
        name: 'getLastUpdated',
        args: [
          appTitle,
          packageVersion,
          appVersion,
        ],
      );

  addMessage(
    String message, {
    String? name,
    List<Object>? args,
  }) =>
      Intl.message(
        message,
        name: (name == null) ? message.camelCase() : name,
        args: args,
        locale: locale.toString(),
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(
    Locale locale,
  ) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(
    AppLocalizationsDelegate old,
  ) =>
      false;

  @override
  bool isSupported(
    Locale locale,
  ) =>
      locale.languageCode
          .toLowerCase()
          .contains(AppConfig.instance.supportedLocales!);
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(
    Locale locale,
  ) =>
      true;

  @override
  Future<CupertinoLocalizations> load(
    Locale locale,
  ) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(
    FallbackCupertinoLocalisationsDelegate old,
  ) =>
      false;
}
