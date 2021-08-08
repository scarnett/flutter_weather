import 'package:cloud_firestore/cloud_firestore.dart';

class Screenshot {
  final String url;

  Screenshot({
    required this.url,
  });

  factory Screenshot.fromSnapshot(
    DocumentSnapshot snapshot,
  ) =>
      Screenshot(
        url: snapshot['url'],
      );
}
