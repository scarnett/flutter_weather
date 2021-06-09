import 'package:flutter_weather/app/app_config.dart';
import 'package:http/http.dart';

Future<Response> connectivityStatus() async =>
    get(Uri.parse(AppConfig.instance.appConnectivityStatus));
