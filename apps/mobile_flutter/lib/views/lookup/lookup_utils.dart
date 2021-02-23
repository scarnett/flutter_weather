import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/localization.dart';

String getTitle(BuildContext context, num _currentPage) {
  if ((_currentPage != null) && (_currentPage.toInt() == 1)) {
    return AppLocalizations.of(context).country;
  }

  return AppLocalizations.of(context).addForecast;
}
