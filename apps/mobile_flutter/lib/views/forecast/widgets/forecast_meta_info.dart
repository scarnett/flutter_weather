import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';

class ForecastMetaInfo extends StatelessWidget {
  final String value;
  final String unit;

  const ForecastMetaInfo({
    Key? key,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 16.0,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              unit,
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
