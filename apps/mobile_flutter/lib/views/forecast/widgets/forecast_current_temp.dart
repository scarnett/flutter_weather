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
  final Animation<double>? resizeAnimation;

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
    this.resizeAnimation,
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
                    style: getTemperatureTextStyle(context),
                    unit: temperatureUnit,
                  ),
                  AppTemperatureDisplay(
                    temperature: AppLocalizations.of(context)!
                        .getFeelsLike(getTemperature(
                      currentDay.feelsLike!.day,
                      temperatureUnit,
                    ).toString()),
                    style: getFeelsLikeTextStyle(context),
                    unit: temperatureUnit,
                    unitSizeFactor: 1.5,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: getTemperaturePadding(context)),
                child: ForecastIcon(
                  icon: getForecastIconData(currentDay.weather!.first.icon),
                  resizeAnimation: resizeAnimation,
                ),
              ),
            ],
          ),
        ),
      );

  TextStyle getTemperatureTextStyle(
    BuildContext context,
  ) {
    TextStyle style = Theme.of(context).textTheme.headline1!;

    if (resizeAnimation != null) {
      return style.copyWith(
        fontSize: (resizeAnimation == null)
            ? null
            : Tween<double>(
                begin: (style.fontSize! - 40.0),
                end: style.fontSize,
              ).evaluate(resizeAnimation!),
      );
    }

    return style;
  }

  TextStyle getFeelsLikeTextStyle(
    BuildContext context,
  ) {
    TextStyle style = Theme.of(context).textTheme.headline5!;

    if (resizeAnimation != null) {
      return style.copyWith(
        fontSize: (resizeAnimation == null)
            ? null
            : Tween<double>(
                begin: (style.fontSize! - 6.0),
                end: style.fontSize,
              ).evaluate(resizeAnimation!),
      );
    }

    return style;
  }

  double getTemperaturePadding(
    BuildContext context,
  ) {
    if (resizeAnimation != null) {
      return 40.0;
    }

    return Tween<double>(
      begin: 10.0,
      end: 40.0,
    ).evaluate(resizeAnimation!);
  }

  bool isScrollable() =>
      ((shrinkOffset != null) && (maxExtent != null) && (minExtent != null));

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
