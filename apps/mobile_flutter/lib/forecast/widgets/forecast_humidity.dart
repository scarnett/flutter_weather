import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/forecast/widgets/forecast_meta_info.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastHumidity extends StatelessWidget {
  final ForecastDay currentDay;

  const ForecastHumidity({
    Key? key,
    required this.currentDay,
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
              label: AppLocalizations.of(context)!.humidity,
              value: currentDay.humidity.toString(),
              unit: '%',
            ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: ForecastIcon(
                iconSize: 20.0,
                icon: WeatherIcons.humidity,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      );
}
