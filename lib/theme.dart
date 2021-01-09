import 'package:flutter/material.dart';

class AppTheme {
  static Color get primaryColor => Colors.deepPurple[400];
  static Color get secondaryColor => Colors.grey[900];
  static Color get disabledColor => primaryColor.withOpacity(0.5);
  static Color get disabledTextColor => Colors.white.withOpacity(0.3);
  static Color get dangerColor => Colors.red[700];

  static Color getBorderColor(
    ThemeMode themeMode, {
    bool colorTheme: false,
  }) =>
      (themeMode == ThemeMode.dark)
          ? Colors.white.withOpacity(0.05)
          : colorTheme
              ? Colors.white.withOpacity(0.25)
              : secondaryColor.withOpacity(0.05);

  static Color getHintColor(
    ThemeMode themeMode, {
    bool colorTheme: false,
  }) =>
      (themeMode == ThemeMode.dark)
          ? Colors.white.withOpacity(0.3)
          : colorTheme
              ? Colors.white.withOpacity(0.5)
              : secondaryColor.withOpacity(0.3);

  static Color getSectionColor(
    ThemeMode themeMode,
  ) =>
      (themeMode == ThemeMode.dark)
          ? Colors.black.withOpacity(0.3)
          : Colors.grey[100];

  static Color getRadioActiveColor(
    ThemeMode themeMode,
  ) =>
      (themeMode == ThemeMode.dark) ? Colors.white : Colors.grey[700];

  static Color getRadioInactiveColor(
    ThemeMode themeMode,
  ) =>
      (themeMode == ThemeMode.dark) ? Colors.grey[700] : Colors.grey[300];
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
  primaryColor: AppTheme.primaryColor,
  accentColor: Colors.deepPurple[600],
  hintColor: AppTheme.getHintColor(ThemeMode.light),
  fontFamily: 'roboto',
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    elevation: 0.0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: AppTheme.secondaryColor,
        fontSize: 20.0,
      ),
    ),
    iconTheme: IconThemeData(color: AppTheme.secondaryColor),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppTheme.primaryColor,
    elevation: 0.0,
  ),
  iconTheme: IconThemeData(
    color: AppTheme.secondaryColor,
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
        color: AppTheme.primaryColor,
        width: 2.0,
        style: BorderStyle.solid,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppTheme.primaryColor.withOpacity(0.1),
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
  textTheme: _darkTextTheme,
);

ThemeData appColorThemeData = appLightThemeData.copyWith(
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: AppTheme.secondaryColor,
    elevation: 0.0,
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  textTheme: _lightTextTheme.copyWith(
    headline6: TextStyle(
      color: AppTheme.secondaryColor,
      fontSize: 16.0,
      height: 0.9,
    ),
  ),
);

ThemeData appDarkThemeData = appLightThemeData.copyWith(
  scaffoldBackgroundColor: AppTheme.secondaryColor,
  unselectedWidgetColor: Colors.grey[800],
  hintColor: AppTheme.getHintColor(ThemeMode.dark),
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    color: AppTheme.secondaryColor,
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
    backgroundColor: AppTheme.secondaryColor,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: _lightTextTheme,
);

TextTheme _darkTextTheme = TextTheme(
  headline1: TextStyle(
    color: AppTheme.secondaryColor,
    fontSize: 86.0,
    fontWeight: FontWeight.w100,
    height: 0.9,
  ),
  headline3: TextStyle(
    color: AppTheme.secondaryColor,
    fontSize: 40.0,
    height: 0.85,
    fontWeight: FontWeight.w100,
  ),
  headline4: TextStyle(
    color: AppTheme.secondaryColor.withOpacity(0.7),
    fontSize: 24.0,
    fontWeight: FontWeight.w100,
    height: 0.9,
  ),
  headline5: TextStyle(
    color: AppTheme.secondaryColor.withOpacity(0.7),
    fontSize: 16.0,
    height: 0.9,
    fontWeight: FontWeight.w400,
  ),
  headline6: TextStyle(
    color: AppTheme.secondaryColor,
    fontSize: 16.0,
    height: 0.9,
  ),
  subtitle2: TextStyle(
    color: AppTheme.secondaryColor.withOpacity(0.7),
    fontSize: 12.0,
    fontWeight: FontWeight.w100,
  ),
);

TextTheme _lightTextTheme = TextTheme(
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
    fontWeight: FontWeight.w400,
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
);
