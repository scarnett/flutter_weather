import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Product {
  final String documentId;
  final String id;
  final bool enabled;
  final ProductDetails? details;

  Product({
    required this.documentId,
    required this.id,
    required this.enabled,
    this.details,
  });

  factory Product.fromJson(
    Map<dynamic, dynamic> json,
  ) =>
      Product(
        documentId: json['documentId'],
        id: json['id'],
        enabled: json['enabled'],
      );

  factory Product.fromSnapshot(
    DocumentSnapshot snapshot,
  ) =>
      Product(
        documentId: snapshot.id,
        id: snapshot['id'],
        enabled: snapshot['enabled'],
      );

  Map<String, dynamic> toMap(
    Product product,
  ) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = product.id;
    map['enabled'] = product.enabled;
    map['details'] = product.details;
    return map;
  }
}
