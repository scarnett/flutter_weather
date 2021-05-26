import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastHiLo extends StatelessWidget {
  final ForecastDay currentDay;
  final ThemeMode themeMode;
  final bool colorTheme;
  final TemperatureUnit temperatureUnit;

  ForecastHiLo({
    Key? key,
    required this.currentDay,
    required this.themeMode,
    this.colorTheme: false,
    required this.temperatureUnit,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppTheme.getBorderColor(
                      themeMode,
                      colorTheme: colorTheme,
                    ),
                    width: 2.0,
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.hi.toUpperCase(),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  AppTemperatureDisplay(
                    temperature:
                        getTemperature(currentDay.temp!.max, temperatureUnit)
                            .toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(height: 0.85),
                    unit: temperatureUnit,
                    unitSizeFactor: 2.5,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.low.toUpperCase(),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  AppTemperatureDisplay(
                    temperature:
                        getTemperature(currentDay.temp!.min, temperatureUnit)
                            .toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(height: 0.85),
                    unit: temperatureUnit,
                    unitSizeFactor: 2.5,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
