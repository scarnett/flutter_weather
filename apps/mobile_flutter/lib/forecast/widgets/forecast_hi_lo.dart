import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastHiLo extends StatelessWidget {
  final ForecastDay currentDay;

  ForecastHiLo({
    Key? key,
    required this.currentDay,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return Container(
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
                    state.themeMode,
                    colorTheme: state.colorTheme,
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
                  temperature: getTemperature(
                    currentDay.temp!.max,
                    state.units.temperature,
                  ).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(height: 0.85),
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
                  temperature: getTemperature(
                    currentDay.temp!.min,
                    state.units.temperature,
                  ).toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(height: 0.85),
                  unitSizeFactor: 2.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
