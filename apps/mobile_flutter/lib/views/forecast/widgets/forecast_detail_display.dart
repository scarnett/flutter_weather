import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hours.dart';

class ForecastDetailDisplay extends StatefulWidget {
  final Forecast forecast;
  final ThemeMode themeMode;
  final bool colorTheme;
  final TemperatureUnit temperatureUnit;

  ForecastDetailDisplay({
    required this.forecast,
    required this.themeMode,
    this.colorTheme: false,
    required this.temperatureUnit,
  });

  @override
  _ForecastDetailDisplayState createState() => _ForecastDetailDisplayState();
}

class _ForecastDetailDisplayState extends State<ForecastDetailDisplay> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: ForecastHours(
          forecast: widget.forecast,
          temperatureUnit: widget.temperatureUnit,
        ),
      );
}
