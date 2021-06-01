import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppRadioTile<T> extends StatelessWidget {
  final ThemeMode themeMode;
  final String title;
  final T value;
  final T? groupValue;
  final Function(T?)? onTap;

  const AppRadioTile({
    Key? key,
    required this.themeMode,
    required this.title,
    required this.value,
    this.groupValue,
    this.onTap,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      RadioListTile<T>(
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
