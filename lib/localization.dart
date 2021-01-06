import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(
    this.locale,
  );

  static AppLocalizations of(
    BuildContext context,
  ) =>
      Localizations.of<AppLocalizations>(
        context,
        AppLocalizations,
      );

  static String get appTitle => 'Flutter Weather';

  String get settings => addMessage('Settings');
  String get themeMode => addMessage('Theme Mode');
  String get light => addMessage('Light');
  String get dark => addMessage('Dark');
  String get temperatureUnit => addMessage('Temperature Unit');
  String get kelvin => addMessage('Kelvin');
  String get celsius => addMessage('Celsius');
  String get fahrenheit => addMessage('Fahrenheit');
  String get hi => addMessage('Hi');
  String get low => addMessage('Low');
  String get addLocation => addMessage('Add Location');
  String get addThisLocation => addMessage('Add This Location');
  String get editLocation => addMessage('Edit Location');
  String get refreshForecast => addMessage('Refresh Forecast');
  String get forecastCreated => addMessage('Forecast Created');
  String get forecastUpdated => addMessage('Forecast Updated');
  String get forecastRemoved => addMessage('Forecast Removed');
  String get postalCode => addMessage('Postal Code');
  String get country => addMessage('Country');
  String get lookup => addMessage('Lookup');
  String get lookupSuccess => addMessage('Location added successfully!');
  String get lookupFailure => addMessage(
      'There was an error looking up this location. Please try again.');

  String get selectCountry => addMessage('Select a country');
  String get filterCountries => addMessage('Filter Countries');

  String getFeelsLike(
    String temp,
  ) =>
      addMessage(
        'Feels like $temp',
        name: 'getLastUpdated',
        args: [temp],
      );

  String getLastUpdatedAt(
    String date,
  ) =>
      addMessage(
        'Last updated at $date',
        name: 'getLastUpdated',
        args: [date],
      );

  String getLastUpdatedOn(
    String date,
  ) =>
      addMessage(
        'Last updated on $date',
        name: 'getLastUpdated',
        args: [date],
      );

  addMessage(
    String message, {
    String name,
    List<Object> args,
  }) =>
      Intl.message(
        message,
        name: (name == null) ? toCamelCase(message) : name,
        args: args,
        locale: locale.toString(),
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  @override
  Future<AppLocalizations> load(
    Locale locale,
  ) =>
      Future(() => AppLocalizations(locale));

  @override
  bool shouldReload(
    AppLocalizationsDelegate old,
  ) =>
      false;

  @override
  bool isSupported(
    Locale locale,
  ) =>
      locale.languageCode.toLowerCase().contains('en'); // TODO! config
}
