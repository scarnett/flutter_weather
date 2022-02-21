import 'package:cloud_firestore/cloud_firestore.dart';

class Screenshot {
  final String colorized;
  final String light;
  final String dark;

  Screenshot({
    required this.colorized,
    required this.light,
    required this.dark,
  });

  factory Screenshot.fromSnapshot(
    DocumentSnapshot snapshot,
  ) =>
      Screenshot(
        colorized: snapshot['colorized'],
        light: snapshot['light'],
        dark: snapshot['dark'],
      );
}
