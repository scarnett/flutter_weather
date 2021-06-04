import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
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
                decoration: BoxDecoration(
                  border: Border(right: _getBorder(context)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: _getBorder(context)),
                      ),
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
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppTheme.getBorderColor(
                        context.read<AppBloc>().state.themeMode,
                        colorTheme: context.read<AppBloc>().state.colorTheme,
                      ),
                      width: 2.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        border: Border(bottom: _getBorder(context)),
                      ),
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
                      decoration: BoxDecoration(
                        border: Border(bottom: _getBorder(context)),
                      ),
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

  BorderSide _getBorder(
    BuildContext context,
  ) =>
      BorderSide(
        color: AppTheme.getBorderColor(
          context.read<AppBloc>().state.themeMode,
          colorTheme: context.read<AppBloc>().state.colorTheme,
        ),
        width: 2.0,
      );
}
