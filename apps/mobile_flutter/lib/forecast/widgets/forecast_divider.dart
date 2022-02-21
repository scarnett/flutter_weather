import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';

class ForecastDivider extends StatelessWidget {
  final EdgeInsets padding;

  const ForecastDivider({
    Key? key,
    this.padding: const EdgeInsets.only(
      left: 10.0,
      right: 10.0,
      bottom: 20.0,
      top: 10.0,
    ),
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Padding(
        padding: padding,
        child: Divider(
          thickness: 2.0,
          color: AppTheme.getBorderColor(
            context.read<AppBloc>().state.themeMode,
            colorTheme: context.read<AppBloc>().state.colorTheme,
          ),
        ),
      );
}
