import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_tile.dart';

class ForecastHours extends StatefulWidget {
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final bool colorTheme;

  ForecastHours({
    required this.forecast,
    required this.temperatureUnit,
    this.colorTheme: false,
  });

  @override
  _ForecastHoursState createState() => _ForecastHoursState();
}

class _ForecastHoursState extends State<ForecastHours> {
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
          hour: widget.forecast.details!.hourly![index],
          temperatureUnit: widget.temperatureUnit,
          colorTheme: widget.colorTheme,
        ),
        separatorBuilder: (context, index) => Divider(),
        padding: const EdgeInsets.all(0.0),
        itemCount: (widget.forecast.details!.hourly != null)
            ? widget.forecast.details!.hourly!.length
            : 0,
      );
}
