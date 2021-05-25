import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';

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
        dense: true,
        leading: Text(
          formatHour(widget.hour.dt) ?? '',
          style: Theme.of(context).textTheme.headline5!,
        ),
        title: Row(
          children: <Widget>[
            ForecastIcon(
              containerSize: 30.0,
              iconSize: 20.0,
              icon: getForecastIconData(
                (widget.hour.weather == null)
                    ? null
                    : widget.hour.weather!.first.icon,
              ),
              shadowColor: Colors.black26,
            ),
          ],
        ),
        onTap: null,
      );
}
