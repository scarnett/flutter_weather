import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppDayNightSwitch extends StatelessWidget {
  final AppBloc bloc;

  const AppDayNightSwitch({
    Key key,
    this.bloc,
  })  : assert(bloc != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      FlutterSwitch(
        width: 60.0,
        height: 28.0,
        toggleSize: 24.0,
        borderRadius: 24.0,
        padding: 1.0,
        value: (bloc.state.themeMode == ThemeMode.dark),
        activeToggleColor: Colors.deepPurple[400],
        inactiveToggleColor: Colors.grey[900],
        activeSwitchBorder: Border.all(
          color: Colors.deepPurple[500],
          width: 2.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: Colors.grey[300],
          width: 2.0,
        ),
        activeColor: Colors.grey[900],
        inactiveColor: Colors.white,
        activeIcon: Icon(
          Icons.nightlight_round,
          color: Colors.yellow[400],
          size: 16.0,
        ),
        inactiveIcon: Icon(
          Icons.wb_sunny,
          color: Colors.amber[500],
          size: 16.0,
        ),
        onToggle: (val) => bloc.add(ToggleThemeMode()),
      );
}
