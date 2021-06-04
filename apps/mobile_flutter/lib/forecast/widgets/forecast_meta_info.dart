import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class ForecastMetaInfo extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const ForecastMetaInfo({
    Key? key,
    required this.label,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontSize: 10.0,
                  ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 16.0,
                      height: 1.0,
                    ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(
                    unit,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          color: AppTheme.getHintColor(
                            context.read<AppBloc>().state.themeMode,
                            colorTheme:
                                context.read<AppBloc>().state.colorTheme,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
}
