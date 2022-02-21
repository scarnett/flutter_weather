import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastUVIndex extends StatelessWidget {
  final ForecastDetails details;

  const ForecastUVIndex({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ForecastMetaInfo(
              label: AppLocalizations.of(context)!.uvIndex,
              value: (details.current == null)
                  ? '0'
                  : (details.current!.uvi ?? 0)
                      .toDouble()
                      .formatDecimal(decimals: 1)
                      .toString(),
              unit: '', // TODO!
            ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: ForecastIcon(
                iconSize: 20.0,
                icon: WeatherIcons.day_sunny,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      );
}
