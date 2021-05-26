import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_tile.dart';

class ForecastHours extends StatelessWidget {
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final bool colorTheme;
  final int maxHours;

  ForecastHours({
    required this.forecast,
    required this.temperatureUnit,
    this.colorTheme: false,
    this.maxHours: 24,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (
          BuildContext context,
          int index,
        ) =>
            ForecastHourTile(
          hour: forecast.details!.hourly![index],
          temperatureUnit: temperatureUnit,
          colorTheme: colorTheme,
        ),
        separatorBuilder: (context, index) => Divider(),
        padding: const EdgeInsets.all(0.0),
        itemCount: _getHourCount(),
      );

  int _getHourCount() {
    if (forecast.details!.hourly != null) {
      int count = forecast.details!.hourly!.length;
      if (count < maxHours) {
        return count;
      }

      return maxHours;
    }

    return 0;
  }
}
