import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppProgressIndicator extends StatelessWidget {
  final Color? color;
  final double strokeWidth;

  const AppProgressIndicator({
    Key? key,
    this.color,
    this.strokeWidth: 2.0,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor:
            AlwaysStoppedAnimation<Color>(color ?? getDefaultColor(context)),
      );

  Color getDefaultColor(
    BuildContext context,
  ) =>
      (context.read<AppBloc>().state.themeMode == ThemeMode.dark) ||
              context.read<AppBloc>().state.colorTheme
          ? Colors.white
          : AppTheme.primaryColor;
}
