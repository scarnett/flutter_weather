import 'package:flutter_weather/models/models.dart';
import 'package:http/http.dart' as http;

Future<http.Response> connectivityStatus({
  required http.Client client,
  required Config config,
}) async =>
    client.get(Uri.parse(config.appConnectivityStatus));
