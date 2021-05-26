import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class AppTemperatureDisplay extends StatelessWidget {
  final String temperature;
  final TextStyle? style;
  final TemperatureUnit? unit;
  final num unitSizeFactor;
  final double scaleFactor;

  AppTemperatureDisplay({
    required this.temperature,
    this.style,
    this.unit,
    this.unitSizeFactor: 3.5,
    this.scaleFactor: 1.0,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            temperature,
            style: style,
            textScaleFactor: scaleFactor,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              getUnitSymbol(unit),
              style: style!.copyWith(
                fontSize: (style!.fontSize! / unitSizeFactor),
              ),
              textScaleFactor: scaleFactor,
            ),
          ),
        ],
      );
}
