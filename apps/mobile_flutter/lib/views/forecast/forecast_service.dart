import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/lookup/lookup_enums.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchCurrentForecastByCoords({
  required num longitude,
  required num latitude,
}) async {
  Map<String, dynamic> params = Map<String, dynamic>();
  params['lon'] = longitude.toString();
  params['lat'] = latitude.toString();
  return http.get(getCurrentApiUri(params));
}

Future<http.Response> tryLookupForecast(
  Map<String, dynamic> lookupData, {
  LookupType lookupType: LookupType.DAILY,
}) async {
  Map<String, dynamic> params = buildLookupParams(lookupData);

  switch (lookupType) {
    case LookupType.HOURLY:
      return http.get(getHourlyApiUri(params));

    case LookupType.DAILY:
    default:
      return http.get(getDailyApiUri(params));
  }
}
