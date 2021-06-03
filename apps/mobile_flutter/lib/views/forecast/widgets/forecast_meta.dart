import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_dew_point.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_humidity.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_pressure.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_uv_index.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_visibility.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_wind_speed.dart';

class ForecastMeta extends StatelessWidget {
  final ForecastDetails details;
  final ForecastDay currentDay;

  const ForecastMeta({
    Key? key,
    required this.details,
    required this.currentDay,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ForecastWindSpeed(currentDay: currentDay),
                ),
                ForecastVisibility(details: details),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ForecastPressure(currentDay: currentDay),
                ),
                ForecastDewPoint(details: details),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ForecastHumidity(currentDay: currentDay),
                ),
                ForecastUVIndex(details: details),
              ],
            ),
          ],
        ),
      );
}
