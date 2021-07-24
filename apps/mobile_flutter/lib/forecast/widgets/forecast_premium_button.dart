import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';

class ForecastPremiumButton extends StatelessWidget {
  const ForecastPremiumButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Tooltip(
        message: AppLocalizations.of(context)!.premium,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              child: AppPremiumTrigger(),
              onTap: () => {},
            ),
          ),
        ),
      );
}
