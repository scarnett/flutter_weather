import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppUiOverlayStyle extends StatefulWidget {
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
  _AppUiOverlayStyleState createState() => _AppUiOverlayStyleState();
}

class _AppUiOverlayStyleState extends State<AppUiOverlayStyle> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness:
              (widget.themeMode == ThemeMode.light) && !widget.colorTheme
                  ? Brightness.light
                  : Brightness.dark,
          statusBarIconBrightness:
              (widget.themeMode == ThemeMode.light) && !widget.colorTheme
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarColor:
              widget.colorTheme && (widget.systemNavigationBarColor != null)
                  ? widget.systemNavigationBarColor!.withOpacity(0.925)
                  : Theme.of(context).appBarTheme.color,
          systemNavigationBarIconBrightness:
              (widget.systemNavigationBarIconBrightness != null)
                  ? widget.systemNavigationBarIconBrightness
                  : (widget.themeMode == ThemeMode.light) && !widget.colorTheme
                      ? Brightness.dark
                      : Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: widget.child!,
      );
}
