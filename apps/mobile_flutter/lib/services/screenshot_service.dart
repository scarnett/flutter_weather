import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_weather/models/models.dart';

Future<List<Screenshot>> getScreenshots() async {
  CollectionReference screenshotRef =
      FirebaseFirestore.instance.collection('screenshots');

  QuerySnapshot screenshotSnapshot = await screenshotRef.get();
  return screenshotSnapshot.docs
      .map((QueryDocumentSnapshot<Object?> snapshot) =>
          Screenshot.fromSnapshot(snapshot))
      .toList();
}
