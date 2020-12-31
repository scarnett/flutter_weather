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
  String get celsius => addMessage('Celsius');
  String get fahrenheit => addMessage('Fahrenheit');
  String get hi => addMessage('Hi');
  String get low => addMessage('Low');

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
