import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

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
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: ForecastWindSpeed(currentDay: currentDay),
                    ),
                    ForecastVisibility(details: details),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: ForecastPressure(currentDay: currentDay),
                    ),
                    ForecastDewPoint(details: details),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: ForecastHumidity(currentDay: currentDay),
                    ),
                    ForecastUVIndex(details: details),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
