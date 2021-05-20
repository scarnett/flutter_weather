import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';

class AppDayNightSwitch extends StatefulWidget {
  final AppBloc bloc;
  final IconData activeIcon;
  final IconData inactiveIcon;

  AppDayNightSwitch({
    Key? key,
    required this.bloc,
    this.activeIcon: Icons.nightlight_round,
    this.inactiveIcon: Icons.wb_sunny,
  }) : super(key: key);

  @override
  _AppDayNightSwitchState createState() => _AppDayNightSwitchState();
}

class _AppDayNightSwitchState extends State<AppDayNightSwitch> {
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
        value: (widget.bloc.state.themeMode == ThemeMode.dark),
        activeToggleColor: AppTheme.primaryColor,
        inactiveToggleColor: widget.bloc.state.colorTheme
            ? Colors.white
            : AppTheme.secondaryColor,
        activeSwitchBorder: Border.all(
          color: Colors.deepPurple[500]!,
          width: 2.0,
        ),
        inactiveSwitchBorder: Border.all(
          color:
              widget.bloc.state.colorTheme ? Colors.white : Colors.grey[300]!,
          width: 2.0,
        ),
        activeColor: AppTheme.secondaryColor,
        inactiveColor: Colors.white.withOpacity(0.5),
        activeIcon: Icon(
          widget.activeIcon,
          color: Colors.yellow[400],
          size: 16.0,
        ),
        inactiveIcon: Icon(
          widget.inactiveIcon,
          color: Colors.amber[500],
          size: 16.0,
        ),
        onToggle: (val) => widget.bloc.add(ToggleThemeMode()),
      );
}
