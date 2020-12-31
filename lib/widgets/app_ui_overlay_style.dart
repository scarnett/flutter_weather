import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppUiOverlayStyle extends StatelessWidget {
  final AppBloc bloc;
  final Widget child;

  const AppUiOverlayStyle({
    Key key,
    this.bloc,
    this.child,
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
          statusBarIconBrightness: (bloc.state.themeMode == ThemeMode.light)
              ? Brightness.dark
              : Brightness.light,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          systemNavigationBarIconBrightness:
              (bloc.state.themeMode == ThemeMode.light)
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: child,
      );
}
