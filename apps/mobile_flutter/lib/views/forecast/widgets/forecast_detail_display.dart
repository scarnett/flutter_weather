import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hours.dart';

class ForecastDetailDisplay extends StatefulWidget {
  final ScrollController scrollController;
  final Forecast forecast;
  final ThemeMode themeMode;
  final bool colorTheme;
  final TemperatureUnit temperatureUnit;

  ForecastDetailDisplay({
    required this.scrollController,
    required this.forecast,
    required this.themeMode,
    this.colorTheme: false,
    required this.temperatureUnit,
  });

  @override
  _ForecastDetailDisplayState createState() => _ForecastDetailDisplayState();
}

class _ForecastDetailDisplayState extends State<ForecastDetailDisplay> {
  double scrollOffset = 0.2;

  @override
  void initState() {
    widget.scrollController
      ..addListener(() => setState(() => scrollOffset = getScrollProgress(
            shrinkOffset: widget.scrollController.offset,
            minExtent: 0.0,
            maxExtent: 50.0,
            clampLower: 0.2,
            speed: 1.5,
          )));

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Opacity(
        opacity: scrollOffset,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: ForecastHours(
            forecast: widget.forecast,
            temperatureUnit: widget.temperatureUnit,
            colorTheme: widget.colorTheme,
          ),
        ),
      );
}
