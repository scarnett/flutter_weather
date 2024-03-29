import 'package:flutter/material.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastLocation extends StatelessWidget {
  final Forecast forecast;
  final double? shrinkOffset;
  final double? maxExtent;
  final double? minExtent;
  final Animation<double>? resizeAnimation;
  final Animation<double>? opacityAnimation;

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
    this.opacityAnimation,
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
                overflow: TextOverflow.ellipsis,
                style: getCityNameTextStyle(context),
              ),
              Text(
                forecast.getLocationText(includeCityName: false),
                style: getLocationTextStyle(context),
              ),
              if (forecast.hasAlerts() && (opacityAnimation != null))
                Opacity(
                  opacity: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).evaluate(opacityAnimation!),
                  child: ForecastAlertButton(
                    forecast: forecast,
                    compact: true,
                  ),
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
