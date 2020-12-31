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
  unselectedWidgetColor: Colors.grey[300],
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    elevation: 0.0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.grey[900],
        fontSize: 20.0,
        fontFamily: 'gilroy',
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey[900]),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey[900],
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    },
  ),
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.grey[900],
      fontWeight: FontWeight.w700,
      fontSize: 16.0,
    ),
  ),
);

ThemeData appDarkThemeData = appLightThemeData.copyWith(
  scaffoldBackgroundColor: Colors.grey[900],
  unselectedWidgetColor: Colors.grey[800],
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Colors.grey[900],
    elevation: 0.0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontFamily: 'gilroy',
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  dividerColor: Colors.black,
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textTheme: TextTheme(
    headline6: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 16.0,
    ),
  ),
);
