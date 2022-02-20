import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';

class AppCheckboxTile extends StatelessWidget {
  final String title;
  final bool checked;
  final Function(bool?)? onTap;

  const AppCheckboxTile({
    Key? key,
    required this.title,
    required this.checked,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            color: checked
                ? AppTheme.getRadioActiveColor(
                    context.read<AppBloc>().state.themeMode)
                : AppTheme.getRadioInactiveColor(
                    context.read<AppBloc>().state.themeMode),
          ),
        ),
        value: checked,
        onChanged: onTap,
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: AppTheme.primaryColor,
      );
}
