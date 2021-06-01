import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_weather/theme.dart';

class AppDayNightSwitch extends StatelessWidget {
  final ThemeMode themeMode;
  final bool colorTheme;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final Function callback;

  AppDayNightSwitch({
    Key? key,
    required this.themeMode,
    required this.colorTheme,
    this.activeIcon: Icons.nightlight_round,
    this.inactiveIcon: Icons.wb_sunny,
    required this.callback,
  }) : super(key: key);

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
        value: (themeMode == ThemeMode.dark),
        activeToggleColor: AppTheme.primaryColor,
        inactiveToggleColor:
            colorTheme ? Colors.white : AppTheme.secondaryColor,
        activeSwitchBorder: Border.all(
          color: Colors.deepPurple[500]!,
          width: 2.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: colorTheme ? Colors.white : Colors.grey[300]!,
          width: 2.0,
        ),
        activeColor: AppTheme.secondaryColor.withOpacity(0.5),
        inactiveColor: Colors.white.withOpacity(0.5),
        activeIcon: Icon(
          activeIcon,
          color: Colors.yellow[400],
          size: 16.0,
        ),
        inactiveIcon: Icon(
          inactiveIcon,
          color: Colors.amber[500],
          size: 16.0,
        ),
        onToggle: (bool val) => callback(),
      );
}
