import 'package:firebase_messaging/firebase_messaging.dart';

Future<bool> requestPushNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  switch (settings.authorizationStatus) {
    case AuthorizationStatus.authorized:
    case AuthorizationStatus.provisional:
      return Future.value(true);

    default:
      return Future.value(false);
  }
}
