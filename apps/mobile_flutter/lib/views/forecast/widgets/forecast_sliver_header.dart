import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_extension.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_current_temp.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_location.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_options.dart';

class ForecastSliverHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final Color? forecastColor;
  final bool colorTheme;

  ForecastSliverHeader({
    required this.context,
    required this.forecast,
    required this.temperatureUnit,
    this.forecastColor,
    this.colorTheme: false,
  });

  @override
  double get minExtent => (MediaQuery.of(context).padding.top + 160.0);

  @override
  double get maxExtent => (MediaQuery.of(context).padding.top + 230.0);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _backgroundColor,
              _backgroundColor.withOpacity(0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: EdgeInsets.only(
          top: (MediaQuery.of(context).padding.top + ForecastOptions.height),
          bottom: 10.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              ForecastLocation(
                forecast: forecast,
                shrinkOffset: shrinkOffset,
                maxExtent: maxExtent,
                minExtent: minExtent,
              ),
              ForecastCurrentTemp(
                currentDay: forecast.list!.first,
                temperatureUnit: temperatureUnit,
                shrinkOffset: shrinkOffset,
                maxExtent: maxExtent,
                minExtent: minExtent,
              ),
            ],
          ),
        ),
      );

  Color get _backgroundColor {
    if (colorTheme) {
      if (forecastColor != null) {
        return forecastColor!.withOpacity(0.8);
      }

      return forecast.getTemperatureColor().withOpacity(0.8);
    }

    return Theme.of(context).appBarTheme.color!;
  }
}
