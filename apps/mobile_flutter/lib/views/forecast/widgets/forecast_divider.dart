import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';

class ForecastDivider extends StatelessWidget {
  final EdgeInsets padding;

  const ForecastDivider({
    Key? key,
    this.padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
