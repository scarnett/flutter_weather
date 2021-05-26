import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/theme.dart';

class ForecastDivider extends StatelessWidget {
  final ThemeMode themeMode;
  final bool colorTheme;

  const ForecastDivider({
    Key? key,
    required this.themeMode,
    this.colorTheme: false,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Divider(
          thickness: 2.0,
          color: AppTheme.getBorderColor(
            themeMode,
            colorTheme: colorTheme,
          ),
        ),
      );
}
