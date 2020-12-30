import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color background = Color.fromRGBO(252, 253, 255, 1);
  static const Color primary = Color.fromRGBO(131, 100, 251, 1.0);
  static const Color accent = Color.fromRGBO(157, 168, 253, 1.0);
  static const Color avatar = AppColors.accent;
  static const Color text = Color.fromRGBO(77, 74, 86, 1.0);
  static const Color hint = Color.fromRGBO(201, 202, 214, 1.0);
  static const Color success = AppColors.primary;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;
  static Color border = Colors.grey[300];
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

ThemeData appThemeData = ThemeData(
  fontFamily: 'gilroy',
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  accentColor: AppColors.accent,
  textSelectionColor: AppColors.primary,
  textSelectionHandleColor: AppColors.accent,
  cursorColor: AppColors.primary,
  textTheme: const TextTheme(
    headline3: TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w900,
      fontSize: 40.0,
      letterSpacing: -1.5,
    ),
    headline5: TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w900,
      fontSize: 24.0,
      letterSpacing: -1.5,
    ),
    headline6: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w700,
      fontSize: 16.0,
    ),
    subtitle2: const TextStyle(
      color: AppColors.hint,
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: AppColors.background,
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: AppColors.hint,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.background,
    selectedItemColor: AppColors.accent,
    selectedLabelStyle: TextStyle(
      color: AppColors.accent,
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
    ),
    unselectedItemColor: AppColors.hint,
    unselectedLabelStyle: TextStyle(
      color: AppColors.hint,
      fontWeight: FontWeight.w700,
      fontSize: 12.0,
    ),
    showUnselectedLabels: true,
    showSelectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.primary,
    disabledColor: Colors.white.withOpacity(0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0),
    ),
    colorScheme: ColorScheme.dark(),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    shape: null,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: AppColors.accent,
    unselectedLabelColor: AppColors.hint,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14.0,
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 14.0,
    ),
    labelPadding: const EdgeInsets.only(
      left: 5.0,
      right: 5.0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.hint,
        width: 2.0,
        style: BorderStyle.solid,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.accent,
        width: 2.0,
        style: BorderStyle.solid,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.hint),
    ),
  ),
  dividerTheme: DividerThemeData(
    color: AppColors.border,
    space: 1.0,
    thickness: 1.0,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
);
