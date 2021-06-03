import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_meta_info.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastVisibility extends StatelessWidget {
  final ForecastDetails details;

  const ForecastVisibility({
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
              label: AppLocalizations.of(context)!.visibility,
              value: details.current!.visibility.toString(),
              unit: 'mi',
            ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: ForecastIcon(
                iconSize: 20.0,
                icon: WeatherIcons.horizon,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      );
}
