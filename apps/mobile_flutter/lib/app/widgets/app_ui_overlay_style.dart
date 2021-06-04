import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppUiOverlayStyle extends StatelessWidget {
  final Widget? child;
  final Color? systemNavigationBarColor;
  final Brightness? systemNavigationBarIconBrightness;

  AppUiOverlayStyle({
    this.child,
    this.systemNavigationBarColor,
    this.systemNavigationBarIconBrightness,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            (state.themeMode == ThemeMode.light) && !state.colorTheme
                ? Brightness.light
                : Brightness.dark,
        statusBarIconBrightness:
            (state.themeMode == ThemeMode.light) && !state.colorTheme
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarColor:
            state.colorTheme && (systemNavigationBarColor != null)
                ? systemNavigationBarColor!.withOpacity(0.925)
                : Theme.of(context).appBarTheme.color,
        systemNavigationBarIconBrightness:
            (systemNavigationBarIconBrightness != null)
                ? systemNavigationBarIconBrightness
                : (state.themeMode == ThemeMode.light) && !state.colorTheme
                    ? Brightness.dark
                    : Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: child!,
    );
  }
}
