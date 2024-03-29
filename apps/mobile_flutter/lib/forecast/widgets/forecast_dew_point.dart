import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastDewPoint extends StatelessWidget {
  final ForecastDetails details;

  const ForecastDewPoint({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ForecastMetaInfo(
            label: AppLocalizations.of(context)!.dewPoint,
            value: (details.current == null)
                ? '0'
                : getTemperature(
                    details.current!.dewPoint,
                    state.units.temperature,
                  ).toString(),
            unit: getUnitSymbol(state.units.temperature),
          ),
          SizedBox(
            height: 30.0,
            width: 30.0,
            child: ForecastIcon(
              iconSize: 20.0,
              icon: WeatherIcons.raindrops,
              shadowColor: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
