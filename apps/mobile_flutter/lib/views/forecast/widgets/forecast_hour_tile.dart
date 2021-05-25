import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';

class ForecastHourTile extends StatefulWidget {
  final ForecastHour hour;

  ForecastHourTile({
    required this.hour,
  });

  @override
  _ForecastHourTileState createState() => _ForecastHourTileState();
}

class _ForecastHourTileState extends State<ForecastHourTile> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      ListTile(
        key: Key(widget.hour.dt.toString()),
        title: Text(
          widget.hour.dt.toString(),
          style: Theme.of(context).textTheme.headline5!,
        ),
        onTap: null,
      );
}
