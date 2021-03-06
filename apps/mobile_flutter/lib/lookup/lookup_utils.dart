import 'package:flutter_weather/app/app_localization.dart';

String getLookupTitle(
  AppLocalizations? localization,
  num? currentPage,
) {
  if (localization == null) {
    return '';
  }

  if ((currentPage != null) && (currentPage.toInt() == 1)) {
    return localization.country;
  }

  return localization.addForecast;
}
