import 'package:flutter_weather/models/models.dart';
import 'package:http/http.dart';

Future<Response> connectivityStatus({
  required Client client,
  required Config config,
}) async =>
    client.get(Uri.parse(config.appConnectivityStatus));
