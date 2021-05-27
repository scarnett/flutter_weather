import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_display.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastHourTile extends StatelessWidget {
  final ForecastHour hour;
  final TemperatureUnit temperatureUnit;
  final ThemeMode themeMode;
  final bool colorTheme;

  ForecastHourTile({
    required this.hour,
    required this.temperatureUnit,
    required this.themeMode,
    this.colorTheme: false,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      ListTile(
        key: Key(hour.dt.toString()),
        dense: true,
        contentPadding: const EdgeInsets.all(0.0),
        horizontalTitleGap: 0.0,
        leading: Container(
          width: 70.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: ForecastHourDisplay(
              hour: hour,
              themeMode: themeMode,
              colorTheme: colorTheme,
            ),
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
                  (hour.weather == null) ? null : hour.weather!.first.icon,
                ),
                shadowColor: Colors.black26,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: AppTemperatureDisplay(
                  temperature:
                      getTemperature(hour.temp, temperatureUnit).toString(),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        shadows: colorTheme ? commonTextShadow() : null,
                      ),
                  unit: temperatureUnit,
                  unitSizeFactor: 1.5,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  getHumidity(hour.humidity),
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        shadows: colorTheme ? commonTextShadow() : null,
                      ),
                ),
              ),
            ),
          ],
        ),
        trailing: Container(
          width: 70.0,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              getWind(hour.windSpeed),
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    shadows: colorTheme ? commonTextShadow() : null,
                  ),
            ),
          ),
        ),
        onTap: null,
      );
}
