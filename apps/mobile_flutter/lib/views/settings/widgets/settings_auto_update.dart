import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingsAutoUpdate extends StatelessWidget {
  final ThemeMode themeMode;

  const SettingsAutoUpdate({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[],
      );
}
