import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppUiOverlayStyle extends StatelessWidget {
  final Widget? child;
  final ThemeMode? themeMode;
  final bool colorTheme;
  final Color? systemNavigationBarColor;
  final Brightness? systemNavigationBarIconBrightness;

  AppUiOverlayStyle({
    this.child,
    this.themeMode,
    this.colorTheme: false,
    this.systemNavigationBarColor,
    this.systemNavigationBarIconBrightness,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: (themeMode == ThemeMode.light) && !colorTheme
              ? Brightness.light
              : Brightness.dark,
          statusBarIconBrightness: (themeMode == ThemeMode.light) && !colorTheme
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor:
              colorTheme && (systemNavigationBarColor != null)
                  ? systemNavigationBarColor!.withOpacity(0.925)
                  : Theme.of(context).appBarTheme.color,
          systemNavigationBarIconBrightness:
              (systemNavigationBarIconBrightness != null)
                  ? systemNavigationBarIconBrightness
                  : (themeMode == ThemeMode.light) && !colorTheme
                      ? Brightness.dark
                      : Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: child!,
      );
}
