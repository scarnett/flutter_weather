import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/views/forecast/forecast_extension.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class ForecastLocation extends StatefulWidget {
  final Forecast forecast;
  final double? shrinkOffset;
  final double? maxExtent;
  final double? minExtent;

  const ForecastLocation({
    Key? key,
    required this.forecast,
    this.shrinkOffset,
    this.maxExtent,
    this.minExtent,
  }) : super(key: key);

  @override
  _ForecastLocationState createState() => _ForecastLocationState();
}

class _ForecastLocationState extends State<ForecastLocation> {
  final AlignmentTween _locationAlignTween = AlignmentTween(
    begin: Alignment.topCenter,
    end: Alignment.topLeft,
  );

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
                widget.forecast.city!.name!.toUpperCase(),
                style: Theme.of(context).textTheme.headline3,
                textScaleFactor: _getScrollScale(5.0),
              ),
              Text(
                widget.forecast.getLocationText(),
                style: Theme.of(context).textTheme.headline5,
                textScaleFactor: _getScrollScale(3.0),
              ),
            ],
          ),
        ),
      );

  bool isScrollable() => ((widget.shrinkOffset != null) &&
      (widget.maxExtent != null) &&
      (widget.minExtent != null));

  double? _getScrollScale(
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

    return null;
  }

  AlignmentGeometry _getAlignment() {
    if (isScrollable()) {
      return _locationAlignTween.lerp(
        getScrollProgress(
          shrinkOffset: widget.shrinkOffset!,
          maxExtent: widget.maxExtent!,
          minExtent: widget.minExtent!,
          speed: 0.5,
        ),
      );
    }

    return Alignment.center;
  }
}
