import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class AppTemperatureDisplay extends StatefulWidget {
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
  _AppTemperatureDisplayState createState() => _AppTemperatureDisplayState();
}

class _AppTemperatureDisplayState extends State<AppTemperatureDisplay> {
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
            widget.temperature,
            style: widget.style,
            textScaleFactor: widget.scaleFactor,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              getUnitSymbol(widget.unit),
              style: widget.style!.copyWith(
                fontSize: (widget.style!.fontSize! / widget.unitSizeFactor),
              ),
              textScaleFactor: widget.scaleFactor,
            ),
          ),
        ],
      );
}
