import 'package:flutter_weather/forecast/forecast.dart';
import 'package:http/http.dart';

Future<Response> fetchDetailedForecast({
  required num longitude,
  required num latitude,
}) async {
  Map<String, dynamic> params = Map<String, dynamic>();
  params['lon'] = longitude.toString();
  params['lat'] = latitude.toString();
  return get(getDetailedUri(params));
}

Future<Response> fetchCurrentForecastByCoords({
  required num longitude,
  required num latitude,
}) async {
  Map<String, dynamic> params = Map<String, dynamic>();
  params['lon'] = longitude.toString();
  params['lat'] = latitude.toString();
  return get(getCurrentApiUri(params));
}

Future<Response> tryLookupForecast(
  Map<String, dynamic> lookupData,
) async {
  Map<String, dynamic> params = buildLookupParams(lookupData);
  return get(getDailyApiUri(params));
}
