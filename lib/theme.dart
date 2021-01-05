import 'package:flutter/material.dart';

class AppTheme {
  static Color getSecondaryColor(
    ThemeMode themeMode,
  ) =>
      (themeMode == ThemeMode.dark)
          ? Colors.white.withOpacity(0.1)
          : Colors.grey[900].withOpacity(0.1);
}

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
  scaffoldBackgroundColor: Colors.white,
  unselectedWidgetColor: Colors.grey[300],
  primaryColor: Colors.deepPurple[400],
  accentColor: Colors.deepPurple[600],
  hintColor: Colors.grey[900].withOpacity(0.7),
  fontFamily: 'roboto',
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    elevation: 0.0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.grey[900],
        fontSize: 20.0,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.grey[900]),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple[400],
    elevation: 0.0,
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
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: EdgeInsets.all(10.0),
    isDense: true,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple[400],
        width: 2.0,
        style: BorderStyle.solid,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple[400].withOpacity(0.1),
        width: 2.0,
        style: BorderStyle.solid,
      ),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red[800],
        width: 2.0,
        style: BorderStyle.solid,
      ),
    ),
    errorStyle: TextStyle(
      color: Colors.red[800],
    ),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.grey[900],
      fontSize: 86.0,
      fontWeight: FontWeight.w100,
      height: 0.9,
    ),
    headline3: TextStyle(
      color: Colors.grey[900],
      fontSize: 40.0,
      height: 0.85,
      fontWeight: FontWeight.w100,
    ),
    headline4: TextStyle(
      color: Colors.grey[900].withOpacity(0.7),
      fontSize: 24.0,
      fontWeight: FontWeight.w100,
      height: 0.9,
    ),
    headline5: TextStyle(
      color: Colors.grey[900].withOpacity(0.7),
      fontSize: 16.0,
      height: 0.9,
      fontWeight: FontWeight.w100,
    ),
    headline6: TextStyle(
      color: Colors.grey[900],
      fontSize: 16.0,
      height: 0.9,
    ),
    subtitle2: TextStyle(
      color: Colors.grey[900].withOpacity(0.7),
      fontSize: 12.0,
      fontWeight: FontWeight.w100,
    ),
  ),
);

ThemeData appDarkThemeData = appLightThemeData.copyWith(
  scaffoldBackgroundColor: Colors.grey[900],
  unselectedWidgetColor: Colors.grey[800],
  hintColor: Colors.white.withOpacity(0.5),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: Colors.grey[900],
    elevation: 0.0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  dividerColor: Colors.black,
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey[900],
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 86.0,
      fontWeight: FontWeight.w100,
      height: 0.9,
    ),
    headline3: TextStyle(
      color: Colors.white,
      fontSize: 40.0,
      height: 0.85,
      fontWeight: FontWeight.w100,
    ),
    headline4: TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: 24.0,
      fontWeight: FontWeight.w100,
      height: 0.9,
    ),
    headline5: TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 16.0,
      height: 0.9,
      fontWeight: FontWeight.w100,
    ),
    headline6: TextStyle(
      color: Colors.white,
      fontSize: 16.0,
      height: 0.9,
    ),
    subtitle2: TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontSize: 12.0,
      fontWeight: FontWeight.w100,
    ),
  ),
);
