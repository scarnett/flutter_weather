import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry/sentry.dart';

Future<void> savePushNotification() {
  CollectionReference pushForecasts =
      FirebaseFirestore.instance.collection('push-notification');

  // TODO! post to firebase function instead. the function will save to push-notification

  return pushForecasts
      .add({
        'device': 'deviceId', // TODO!
        'interval': 'interval', // TODO!
      })
      .then((DocumentReference<Object?> value) => print(value.id))
      .catchError((error) async => await Sentry.captureException(error));
}
