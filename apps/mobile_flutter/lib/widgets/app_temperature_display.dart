import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class AppTemperatureDisplay extends StatelessWidget {
  final String temperature;
  final TextStyle? style;
  final TemperatureUnit? unit;
  final num unitSizeFactor;

  AppTemperatureDisplay({
    required this.temperature,
    this.style,
    this.unit,
    this.unitSizeFactor: 3.5,
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
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              getUnitSymbol(unit),
              style: style!.copyWith(
                fontSize: (style!.fontSize! / unitSizeFactor),
              ),
            ),
          ),
        ],
      );
}
