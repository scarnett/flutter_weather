import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast_utils.dart';
import 'package:flutter_weather/forecast/view/view.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastEditButton extends StatelessWidget {
  const ForecastEditButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.watch<AppBloc>().state;
    return !hasForecasts(state.forecasts)
        ? Container()
        : Tooltip(
            message: AppLocalizations.of(context)!.editForecast,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  child: const Icon(Icons.edit),
                  onTap: () => _tapEdit(context, state),
                ),
              ),
            ),
          );
  }

  void _tapEdit(
    BuildContext context,
    AppState state,
  ) {
    if (state.forecasts.length > state.selectedForecastIndex) {
      Forecast? forecast = state.forecasts[state.selectedForecastIndex];
      context.read<AppBloc>().add(SetActiveForecastId(forecast.id));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.push(context, ForecastFormView.route());
    }
  }
}
