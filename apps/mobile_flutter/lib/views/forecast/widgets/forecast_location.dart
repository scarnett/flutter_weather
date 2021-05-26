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
                style: Theme.of(context).textTheme.headline3,
                textScaleFactor: _getScrollScale(5.0),
              ),
              Text(
                forecast.getLocationText(),
                style: Theme.of(context).textTheme.headline5,
                textScaleFactor: _getScrollScale(3.0),
              ),
            ],
          ),
        ),
      );

  bool isScrollable() =>
      ((shrinkOffset != null) && (maxExtent != null) && (minExtent != null));

  double? _getScrollScale(
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

    return null;
  }

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
