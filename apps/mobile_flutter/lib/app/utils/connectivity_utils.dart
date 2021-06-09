import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasConnectivity(
  ConnectivityResult result,
) async {
  switch (result) {
    case ConnectivityResult.none:
      return false;

    case ConnectivityResult.mobile:
    case ConnectivityResult.wifi:
    default:
      break;
  }

  return true;
}
