import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastHourTile extends StatefulWidget {
  final ForecastHour hour;
  final TemperatureUnit temperatureUnit;
  final bool colorTheme;

  ForecastHourTile({
    required this.hour,
    required this.temperatureUnit,
    this.colorTheme: false,
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
        contentPadding: const EdgeInsets.all(0.0),
        leading: Text(
          formatHour(widget.hour.dt) ?? '',
          style: Theme.of(context).textTheme.headline5!.copyWith(
                shadows: widget.colorTheme ? commonTextShadow() : null,
              ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Center(
              child: ForecastIcon(
                containerSize: 30.0,
                iconSize: 20.0,
                icon: getForecastIconData(
                  (widget.hour.weather == null)
                      ? null
                      : widget.hour.weather!.first.icon,
                ),
                shadowColor: Colors.black26,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: AppTemperatureDisplay(
                  temperature:
                      getTemperature(widget.hour.temp, widget.temperatureUnit)
                          .toString(),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        shadows: widget.colorTheme ? commonTextShadow() : null,
                      ),
                  unit: widget.temperatureUnit,
                  unitSizeFactor: 2.0,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  getHumidity(widget.hour.humidity),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        shadows: widget.colorTheme ? commonTextShadow() : null,
                      ),
                ),
              ),
            ),
          ],
        ),
        trailing: Text(
          getWind(widget.hour.windSpeed),
          style: Theme.of(context).textTheme.headline5!.copyWith(
                shadows: widget.colorTheme ? commonTextShadow() : null,
              ),
        ),
        onTap: null,
      );
}
