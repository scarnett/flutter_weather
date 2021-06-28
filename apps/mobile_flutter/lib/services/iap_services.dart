import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_weather/models/product.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

Stream<List<Product>> fetchProducts() => FirebaseFirestore.instance
    .collection('products')
    .where('enabled', isEqualTo: true)
    .snapshots()
    .map((QuerySnapshot snapshot) => _products(snapshot));

List<Product> _products(
  QuerySnapshot snapshot,
) {
  List<Product> list = [];
  list = snapshot.docs
      .map((DocumentSnapshot document) => Product.fromSnapshot(document))
      .toList();

  return list;
}

Future<bool> verifyPurchase(
  PurchaseDetails details,
) async {
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('verifyPurchase');
  final HttpsCallableResult results = await callable({
    'source': details.verificationData.source,
    'verificationData': details.verificationData.serverVerificationData,
    'productId': details.productID,
  });

  return results.data as bool;
}
