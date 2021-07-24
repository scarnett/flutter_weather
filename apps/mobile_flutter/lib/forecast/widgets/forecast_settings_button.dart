import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/settings/view/view.dart';

class ForecastSettingsButton extends StatelessWidget {
  const ForecastSettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Tooltip(
          message: AppLocalizations.of(context)!.settings,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: InkWell(
                borderRadius: BorderRadius.circular(40.0),
                child: const Icon(Icons.settings),
                onTap: () => _tapSettings(context),
              ),
            ),
          ),
        ),
      );

  void _tapSettings(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context, SettingsView.route());
  }
}
