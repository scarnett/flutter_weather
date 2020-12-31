import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

ThemeMode getThemeMode(
  String themeMode,
) {
  switch (themeMode) {
    case 'ThemeMode.dark':
      return ThemeMode.dark;

    case 'ThemeMode.light':
    default:
      return ThemeMode.light;
  }
}

ThemeData appLightThemeData = ThemeData(
  fontFamily: 'gilroy',
  scaffoldBackgroundColor: Colors.white,
  iconTheme: IconThemeData(
    color: Colors.grey[900],
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
);

ThemeData appDarkThemeData = appLightThemeData.copyWith(
  scaffoldBackgroundColor: Colors.grey[900],
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
);
