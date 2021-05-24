import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_options.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastSliverHeader extends SliverPersistentHeaderDelegate {
  final BuildContext context;
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;

  final AlignmentTween _locationAlignTween = AlignmentTween(
    begin: Alignment.topCenter,
    end: Alignment.topLeft,
  );

  final AlignmentTween _currentTemperatureAlignTween = AlignmentTween(
    begin: Alignment.bottomCenter,
    end: Alignment.topRight,
  );

  ForecastSliverHeader({
    required this.context,
    required this.forecast,
    required this.temperatureUnit,
  });

  @override
  double get minExtent => (MediaQuery.of(context).padding.top + 160.0);

  @override
  double get maxExtent => (MediaQuery.of(context).padding.top + 220.0);

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
              Theme.of(context).appBarTheme.color!,
              Theme.of(context).appBarTheme.color!.withOpacity(0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + ForecastOptions.height,
          bottom: 10.0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              _buildLocation(shrinkOffset),
              _buildCurrentTemperature(
                forecast.list!.first,
                shrinkOffset,
              ),
            ],
          ),
        ),
      );

  Widget _buildLocation(
    double shrinkOffset,
  ) =>
      Align(
        alignment:
            _locationAlignTween.lerp(getProgress(shrinkOffset: shrinkOffset)),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                forecast.city!.name!.toUpperCase(),
                style: Theme.of(context).textTheme.headline3,
                textScaleFactor: getScale(
                  shrinkOffset: shrinkOffset,
                  factor: 5.0,
                ),
              ),
              Text(
                getLocationText(forecast),
                style: Theme.of(context).textTheme.headline5,
                textScaleFactor: getScale(
                  shrinkOffset: shrinkOffset,
                  factor: 3.0,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCurrentTemperature(
    ForecastDay currentDay,
    double shrinkOffset,
  ) =>
      Container(
        child: Align(
          alignment: _currentTemperatureAlignTween
              .lerp(getProgress(shrinkOffset: shrinkOffset)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppTemperatureDisplay(
                    temperature:
                        getTemperature(currentDay.temp!.day, temperatureUnit)
                            .toString(),
                    style: Theme.of(context).textTheme.headline1,
                    scaleFactor: getScale(
                      shrinkOffset: shrinkOffset,
                      factor: 2.0,
                    ),
                    unit: temperatureUnit,
                  ),
                  AppTemperatureDisplay(
                    temperature: AppLocalizations.of(context)!.getFeelsLike(
                        getTemperature(
                                currentDay.feelsLike!.day, temperatureUnit)
                            .toString()),
                    style: Theme.of(context).textTheme.headline5,
                    scaleFactor: getScale(
                      shrinkOffset: shrinkOffset,
                      factor: 3.0,
                    ),
                    unit: temperatureUnit,
                    unitSizeFactor: 1.5,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: (40.0 *
                        getScale(shrinkOffset: shrinkOffset, factor: 1.5))),
                child: ForecastIcon(
                  icon: getForecastIconData(currentDay.weather!.first.icon),
                  scaleFactor: getScale(
                    shrinkOffset: shrinkOffset,
                    factor: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  double getProgress({
    required double shrinkOffset,
    double speed: 1.0,
  }) =>
      ((shrinkOffset * speed) / (this.maxExtent - this.minExtent))
          .clamp(0.0, 1.0);

  double getScale({
    required double shrinkOffset,
    double factor: 4.0,
  }) {
    double position = (getProgress(shrinkOffset: shrinkOffset) / factor);
    return (1.0 - position);
  }
}
