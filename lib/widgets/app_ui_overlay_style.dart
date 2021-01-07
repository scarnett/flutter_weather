import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppUiOverlayStyle extends StatelessWidget {
  final AppBloc bloc;
  final Widget child;
  final Color systemNavigationBarColor;
  final Brightness systemNavigationBarIconBrightness;

  const AppUiOverlayStyle({
    Key key,
    this.bloc,
    this.child,
    this.systemNavigationBarColor,
    this.systemNavigationBarIconBrightness,
  })  : assert(bloc != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: (bloc.state.themeMode == ThemeMode.light) &&
                  !bloc.state.colorTheme
              ? Brightness.dark
              : Brightness.light,
          statusBarIconBrightness: (bloc.state.themeMode == ThemeMode.light) &&
                  !bloc.state.colorTheme
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor:
              bloc.state.colorTheme && (systemNavigationBarColor != null)
                  ? systemNavigationBarColor
                  : Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness:
              (systemNavigationBarIconBrightness != null)
                  ? systemNavigationBarIconBrightness
                  : (bloc.state.themeMode == ThemeMode.light) &&
                          !bloc.state.colorTheme
                      ? Brightness.dark
                      : Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: child,
      );
}
