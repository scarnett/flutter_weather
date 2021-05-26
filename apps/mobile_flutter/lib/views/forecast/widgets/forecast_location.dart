import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/views/forecast/forecast_extension.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class ForecastLocation extends StatelessWidget {
  final Forecast forecast;
  final double? shrinkOffset;
  final double? maxExtent;
  final double? minExtent;
  final Animation<double>? resizeAnimation;

  final AlignmentTween _locationAlignTween = AlignmentTween(
    begin: Alignment.topCenter,
    end: Alignment.topLeft,
  );

  ForecastLocation({
    Key? key,
    required this.forecast,
    this.shrinkOffset,
    this.maxExtent,
    this.minExtent,
    this.resizeAnimation,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Align(
        alignment: _getAlignment(),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                forecast.city!.name!.toUpperCase(),
                style: getCityNameTextStyle(context),
              ),
              Text(
                forecast.getLocationText(includeCityName: false),
                style: getLocationTextStyle(context),
              ),
            ],
          ),
        ),
      );

  TextStyle getCityNameTextStyle(
    BuildContext context,
  ) {
    TextStyle style = Theme.of(context).textTheme.headline3!;

    if (resizeAnimation != null) {
      return style.copyWith(
        fontSize: (resizeAnimation == null)
            ? null
            : Tween<double>(
                begin: (style.fontSize! - 14.0),
                end: style.fontSize,
              ).evaluate(resizeAnimation!),
      );
    }

    return style;
  }

  TextStyle getLocationTextStyle(
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

  bool isScrollable() =>
      ((shrinkOffset != null) && (maxExtent != null) && (minExtent != null));

  AlignmentGeometry _getAlignment() {
    if (isScrollable()) {
      return _locationAlignTween.lerp(
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
