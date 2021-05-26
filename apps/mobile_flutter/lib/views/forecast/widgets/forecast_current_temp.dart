import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastCurrentTemp extends StatelessWidget {
  final ForecastDay currentDay;
  final TemperatureUnit temperatureUnit;
  final double? shrinkOffset;
  final double? maxExtent;
  final double? minExtent;

  final AlignmentTween _currentTemperatureAlignTween = AlignmentTween(
    begin: Alignment.bottomCenter,
    end: Alignment.topRight,
  );

  ForecastCurrentTemp({
    Key? key,
    required this.currentDay,
    required this.temperatureUnit,
    this.shrinkOffset,
    this.maxExtent,
    this.minExtent,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: Align(
          alignment: _getAlignment(),
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
                    temperature: getTemperature(
                      currentDay.temp!.day,
                      temperatureUnit,
                    ).toString(),
                    style: Theme.of(context).textTheme.headline1,
                    scaleFactor: _getScrollScale(2.0),
                    unit: temperatureUnit,
                  ),
                  AppTemperatureDisplay(
                    temperature: AppLocalizations.of(context)!
                        .getFeelsLike(getTemperature(
                      currentDay.feelsLike!.day,
                      temperatureUnit,
                    ).toString()),
                    style: Theme.of(context).textTheme.headline5,
                    scaleFactor: _getScrollScale(3.0),
                    unit: temperatureUnit,
                    unitSizeFactor: 1.5,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: (40.0 * _getScrollScale(1.5)),
                ),
                child: ForecastIcon(
                  icon: getForecastIconData(currentDay.weather!.first.icon),
                  scaleFactor: _getScrollScale(2.5),
                ),
              ),
            ],
          ),
        ),
      );

  bool isScrollable() =>
      ((shrinkOffset != null) && (maxExtent != null) && (minExtent != null));

  double _getScrollScale(
    double factor,
  ) {
    if (isScrollable()) {
      return getScrollScale(
        shrinkOffset: shrinkOffset!,
        maxExtent: maxExtent!,
        minExtent: minExtent!,
        factor: factor,
      );
    }

    return 1.0;
  }

  AlignmentGeometry _getAlignment() {
    if (isScrollable()) {
      return _currentTemperatureAlignTween.lerp(
        getScrollProgress(
          shrinkOffset: shrinkOffset!,
          maxExtent: maxExtent!,
          minExtent: minExtent!,
          speed: 0.5,
        ),
      );
    }

    return Alignment.center;
  }
}
