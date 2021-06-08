import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:sentry/sentry.dart';

Future<ConnectivityResult?> initConnectivity(
  bool mounted,
) async {
  ConnectivityResult result;

  try {
    final Connectivity connectivity = Connectivity();
    result = await connectivity.checkConnectivity();
  } on PlatformException catch (exception, stackTrace) {
    await Sentry.captureException(exception, stackTrace: stackTrace);
    return null;
  }

  if (!mounted) {
    return Future.value(null);
  }

  return result;
}
