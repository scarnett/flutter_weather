import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_meta_info.dart';
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
          children: [
            ForecastMetaInfo(
              label: AppLocalizations.of(context)!.uvIndex,
              value: details.current!.uvi.toString(),
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
