import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';

class PremiumService {
  Query<Map<String, dynamic>> productsCollection = FirebaseFirestore.instance
      .collection('products')
      .where('enabled', isEqualTo: true);

  Stream<List<Product>> fetchProducts(
    ProductSource source,
  ) =>
      productsCollection.where('source', isEqualTo: source.str).snapshots().map(
            (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
                .map((QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
                    Product.fromSnapshot(snapshot))
                .toList(),
          );
}
