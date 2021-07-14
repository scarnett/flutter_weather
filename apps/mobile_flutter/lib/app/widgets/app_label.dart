import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';

class AppLabel extends StatelessWidget {
  final String text;
  final Color? colorThemeColor;

  const AppLabel({
    Key? key,
    required this.text,
    this.colorThemeColor,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: context.read<AppBloc>().state.colorTheme
              ? Colors.white
              : AppTheme.primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 2.0,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: context.read<AppBloc>().state.colorTheme
                      ? (colorThemeColor ?? AppTheme.primaryColor)
                      : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ),
      );
}
