import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';

Future<http.Response> tryLookupForecast(
  Map<String, dynamic> lookupData,
) async {
  Map<String, dynamic> params = Map<String, dynamic>();

  if (lookupData.containsKey('postalCode') &&
      !(lookupData['postalCode'] as String).isNullOrEmpty()) {
    if (lookupData.containsKey('countryCode') &&
        !(lookupData['countryCode'] as String).isNullOrEmpty()) {
      params['zip'] =
          '${lookupData['postalCode']},${lookupData['countryCode'].toLowerCase()}';
    } else {
      params['zip'] = lookupData['postalCode'];
    }
  } else if (lookupData.containsKey('cityName') &&
      !(lookupData['cityName'] as String).isNullOrEmpty()) {
    String query = lookupData['cityName'];

    if (lookupData.containsKey('stateCode') &&
        !(lookupData['stateCode'] as String).isNullOrEmpty()) {
      query += ',${lookupData['stateCode']}';
    }

    if (lookupData.containsKey('countryCode') &&
        !(lookupData['countryCode'] as String).isNullOrEmpty()) {
      query += ',${lookupData['countryCode']}';
    }

    params['q'] = query;
  }

  String url = getDailyApiUri(params).toString();
  await Sentry.captureMessage(url);
  return http.get(url);
}
