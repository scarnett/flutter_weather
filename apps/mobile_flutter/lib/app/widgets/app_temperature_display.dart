import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class AppTemperatureDisplay extends StatelessWidget {
  final String temperature;
  final TextStyle? style;
  final num unitSizeFactor;

  AppTemperatureDisplay({
    required this.temperature,
    this.style,
    this.unitSizeFactor: 3.5,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            temperature,
            style: style,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              getUnitSymbol(context.read<AppBloc>().state.units.temperature),
              style: style!.copyWith(
                fontSize: (style!.fontSize! / unitSizeFactor),
              ),
            ),
          ),
        ],
      );
}
