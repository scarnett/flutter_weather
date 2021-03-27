import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/lookup/lookup_enums.dart';
import 'package:http/http.dart' as http;

Future<http.Response> tryLookupForecast(
  Map<String, dynamic> lookupData, {
  LookupType lookupType: LookupType.DAILY,
}) async {
  Map<String, dynamic> params = buildLookupParams(lookupData);

  switch (lookupType) {
    case LookupType.HOURLY:
      return http.get(getHourlyApiUri(params).toString());

    case LookupType.DAILY:
    default:
      return http.get(getDailyApiUri(params).toString());
  }
}
