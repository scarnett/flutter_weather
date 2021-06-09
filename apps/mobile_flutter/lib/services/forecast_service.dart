import 'package:flutter_weather/forecast/forecast.dart';
import 'package:http/http.dart';

Future<Response> fetchDetailedForecast({
  required Client client,
  required num longitude,
  required num latitude,
}) async {
  Map<String, dynamic> params = Map<String, dynamic>();
  params['lon'] = longitude.toString();
  params['lat'] = latitude.toString();
  return client.get(getDetailedUri(params));
}

Future<Response> fetchCurrentForecastByCoords({
  required Client client,
  required num longitude,
  required num latitude,
}) async {
  Map<String, dynamic> params = Map<String, dynamic>();
  params['lon'] = longitude.toString();
  params['lat'] = latitude.toString();
  return client.get(getCurrentApiUri(params));
}

Future<Response> tryLookupForecast({
  required Client client,
  required Map<String, dynamic> lookupData,
}) async {
  Map<String, dynamic> params = buildLookupParams(lookupData);
  return client.get(getDailyApiUri(params));
}
