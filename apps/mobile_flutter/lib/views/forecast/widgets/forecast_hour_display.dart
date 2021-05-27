import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class ForecastHourDisplay extends StatelessWidget {
  final ForecastHour hour;
  final ThemeMode themeMode;
  final bool colorTheme;

  const ForecastHourDisplay({
    Key? key,
    required this.hour,
    required this.themeMode,
    this.colorTheme: false,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Row(
        children: <Widget>[
          Text(
            formatHour(dateTime: hour.dt) ?? '',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  shadows: colorTheme ? commonTextShadow() : null,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              formatHour(dateTime: hour.dt, format: 'a') ?? '',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: AppTheme.getHintColor(
                      themeMode,
                      colorTheme: colorTheme,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      );
}
