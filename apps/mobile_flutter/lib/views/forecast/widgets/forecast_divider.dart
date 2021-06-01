import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/theme.dart';

class ForecastDivider extends StatelessWidget {
  final ThemeMode themeMode;
  final bool colorTheme;
  final EdgeInsets padding;

  const ForecastDivider({
    Key? key,
    required this.themeMode,
    this.colorTheme: false,
    this.padding: const EdgeInsets.symmetric(horizontal: 0.0),
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Padding(
        padding: padding,
        child: Divider(
          thickness: 2.0,
          color: AppTheme.getBorderColor(
            themeMode,
            colorTheme: colorTheme,
          ),
        ),
      );
}
