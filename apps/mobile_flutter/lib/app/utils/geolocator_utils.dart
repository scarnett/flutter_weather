import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestLocationPermission() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.value(false);
  }

  LocationPermission locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    Permission perm = Permission.location;
    PermissionStatus status = await perm.request();
    return Future.value(status.isGranted);
  }

  return Future.value(true);
}

Future<Position?> getPosition() async {
  if (!await requestLocationPermission()) {
    return Future.value(null);
  }

  return await Geolocator.getCurrentPosition();
}
