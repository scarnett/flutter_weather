import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastCondition extends StatelessWidget {
  final ForecastDay currentDay;

  const ForecastCondition({
    Key? key,
    required this.currentDay,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Text(
          currentDay.weather!.first.description!.toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.w300,
              ),
        ),
      );
}
