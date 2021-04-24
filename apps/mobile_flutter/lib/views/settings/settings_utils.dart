import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

String getTitle(
  BuildContext context,
  num _currentPage,
) {
  if (_currentPage.toInt() == 1) {
    return AppLocalizations.of(context)!.updatePeriod;
  }

  return AppLocalizations.of(context)!.settings;
}
