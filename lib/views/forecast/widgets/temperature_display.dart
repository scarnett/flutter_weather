import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class TemperatureDisplay extends StatefulWidget {
  final String temperature;
  final TextStyle style;
  final TemperatureUnit unit;
  final num unitSizeFactor;

  TemperatureDisplay({
    @required this.temperature,
    this.style,
    this.unit,
    this.unitSizeFactor: 2.5,
  });

  @override
  _TemperatureDisplayState createState() => _TemperatureDisplayState();
}

class _TemperatureDisplayState extends State<TemperatureDisplay> {
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
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              getUnitSymbol(widget.unit),
              style: widget.style.copyWith(
                fontSize: (widget.style.fontSize / widget.unitSizeFactor),
              ),
            ),
          ),
        ],
      );
}
