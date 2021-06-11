import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:http/http.dart' as http;

Future<bool> hasConnectivity({
  required http.Client client,
  required Config config,
  ConnectivityResult? result,
}) async {
  if (result != null) {
    switch (result) {
      case ConnectivityResult.none:
        return false;

      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      default:
        break;
    }
  }

  http.Response connectivityResponse = await connectivityStatus(
    client: client,
    config: config,
  );

  if ((connectivityResponse.statusCode == 200) &&
      (connectivityResponse.body == 'ok')) {
    return true;
  }

  return false;
}
