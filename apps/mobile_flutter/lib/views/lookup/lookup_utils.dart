import 'package:flutter_weather/localization.dart';

String getTitle(
  AppLocalizations localization,
  num currentPage,
) {
  if (localization == null) {
    return null;
  }

  if ((currentPage != null) && (currentPage.toInt() == 1)) {
    return localization.country;
  }

  return localization.addForecast;
}
