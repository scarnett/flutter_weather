import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';

class AppRadioTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? groupValue;
  final Function(T?)? onTap;

  const AppRadioTile({
    Key? key,
    required this.title,
    required this.value,
    this.groupValue,
    this.onTap,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    ThemeMode themeMode = context.read<AppBloc>().state.themeMode;

    return RadioListTile<T>(
      title: Text(
        title,
        style: TextStyle(
          color: (value == groupValue)
              ? AppTheme.getRadioActiveColor(themeMode)
              : AppTheme.getRadioInactiveColor(themeMode),
        ),
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onTap,
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: AppTheme.primaryColor,
    );
  }
}
