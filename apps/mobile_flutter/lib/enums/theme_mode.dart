import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_localization.dart';

extension ThemeModeExtension on ThemeMode {
  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;

      case ThemeMode.dark:
      default:
        return AppLocalizations.of(context)!.dark;
    }
  }
}
