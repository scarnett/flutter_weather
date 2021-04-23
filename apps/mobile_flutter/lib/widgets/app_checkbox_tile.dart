import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';

class AppChekboxTile extends StatelessWidget {
  final AppBloc bloc;
  final String title;
  final bool checked;
  final Function(bool?)? onTap;

  const AppChekboxTile({
    Key? key,
    required this.bloc,
    required this.title,
    required this.checked,
    this.onTap,
  })  : assert(bloc != null),
        assert(title != null),
        assert(checked != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            color: checked
                ? AppTheme.getRadioActiveColor(bloc.state.themeMode)
                : AppTheme.getRadioInactiveColor(bloc.state.themeMode),
          ),
        ),
        value: checked,
        onChanged: onTap,
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: AppTheme.primaryColor,
      );
}
