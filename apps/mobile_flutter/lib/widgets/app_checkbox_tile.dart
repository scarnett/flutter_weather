import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppCheckboxTile extends StatelessWidget {
  final ThemeMode themeMode;
  final String title;
  final bool checked;
  final Function(bool?)? onTap;

  const AppCheckboxTile({
    Key? key,
    required this.themeMode,
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
                ? AppTheme.getRadioActiveColor(themeMode)
                : AppTheme.getRadioInactiveColor(themeMode),
          ),
        ),
        value: checked,
        onChanged: onTap,
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: AppTheme.primaryColor,
      );
}
