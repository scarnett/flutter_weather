import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastCurrentTemp extends StatefulWidget {
  final ForecastDay currentDay;
  final TemperatureUnit temperatureUnit;
  final double? shrinkOffset;
  final double? maxExtent;
  final double? minExtent;

  const ForecastCurrentTemp({
    Key? key,
    required this.currentDay,
    required this.temperatureUnit,
    this.shrinkOffset,
    this.maxExtent,
    this.minExtent,
  }) : super(key: key);

  @override
  _ForecastCurrentTempState createState() => _ForecastCurrentTempState();
}

class _ForecastCurrentTempState extends State<ForecastCurrentTemp> {
  final AlignmentTween _currentTemperatureAlignTween = AlignmentTween(
    begin: Alignment.bottomCenter,
    end: Alignment.topRight,
  );

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
                      widget.currentDay.temp!.day,
                      widget.temperatureUnit,
                    ).toString(),
                    style: Theme.of(context).textTheme.headline1,
                    scaleFactor: _getScrollScale(2.0),
                    unit: widget.temperatureUnit,
                  ),
                  AppTemperatureDisplay(
                    temperature: AppLocalizations.of(context)!
                        .getFeelsLike(getTemperature(
                      widget.currentDay.feelsLike!.day,
                      widget.temperatureUnit,
                    ).toString()),
                    style: Theme.of(context).textTheme.headline5,
                    scaleFactor: _getScrollScale(3.0),
                    unit: widget.temperatureUnit,
                    unitSizeFactor: 1.5,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: (40.0 * _getScrollScale(1.5)),
                ),
                child: ForecastIcon(
                  icon: getForecastIconData(
                      widget.currentDay.weather!.first.icon),
                  scaleFactor: _getScrollScale(2.5),
                ),
              ),
            ],
          ),
        ),
      );

  bool isScrollable() => ((widget.shrinkOffset != null) &&
      (widget.maxExtent != null) &&
      (widget.minExtent != null));

  double _getScrollScale(
    double factor,
  ) {
    if (isScrollable()) {
      return getScrollScale(
        shrinkOffset: widget.shrinkOffset!,
        maxExtent: widget.maxExtent!,
        minExtent: widget.minExtent!,
        factor: factor,
      );
    }

    return 1.0;
  }

  AlignmentGeometry _getAlignment() {
    if (isScrollable()) {
      return _currentTemperatureAlignTween.lerp(
        getScrollProgress(
          shrinkOffset: widget.shrinkOffset!,
          maxExtent: widget.maxExtent!,
          minExtent: widget.minExtent!,
        ),
      );
    }

    return Alignment.center;
  }
}
