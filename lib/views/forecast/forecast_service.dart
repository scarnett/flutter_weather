import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:http/http.dart' as http;

Future<http.Response> tryLookupForecast(
  String postalCode, {
  String countryCode,
}) async {
  Map<String, String> params = Map<String, String>();

  if (countryCode == null) {
    params['zip'] = postalCode;
  } else {
    params['zip'] = '$postalCode,${countryCode.toLowerCase()}';
  }

  return http.get(getApiUri(params).toString());
}
