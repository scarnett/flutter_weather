import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/utils/common_utils.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast_utils.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastHourDisplay extends StatelessWidget {
  final ForecastHour hour;

  const ForecastHourDisplay({
    Key? key,
    required this.hour,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Row(
        children: <Widget>[
          Text(
            formatHour(dateTime: hour.dt) ?? '',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  shadows: context.read<AppBloc>().state.colorTheme
                      ? commonTextShadow()
                      : null,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              formatHour(dateTime: hour.dt, format: 'a') ?? '',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: AppTheme.getHintColor(
                      context.read<AppBloc>().state.themeMode,
                      colorTheme: context.read<AppBloc>().state.colorTheme,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      );
}
