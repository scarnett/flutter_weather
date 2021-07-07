import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Product {
  final String documentId;
  final String id;
  final ProductSource? source;
  final bool enabled;
  final ProductDetails? details;

  Product({
    required this.documentId,
    required this.id,
    required this.source,
    required this.enabled,
    this.details,
  });

  String get title => details?.title ?? '';
  String get description => details?.description ?? '';
  String get price => details?.price ?? '';

  factory Product.fromJson(
    Map<dynamic, dynamic> json,
  ) =>
      Product(
        documentId: json['documentId'],
        id: json['id'],
        source: getProductSourceByStr(json['source']),
        enabled: json['enabled'],
      );

  factory Product.fromSnapshot(
    DocumentSnapshot snapshot,
  ) =>
      Product(
        documentId: snapshot.id,
        id: snapshot['id'],
        source: getProductSourceByStr(snapshot['source']),
        enabled: snapshot['enabled'],
      );

  Map<String, dynamic> toMap(
    Product product,
  ) {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = product.id;
    map['source'] = product.source?.str;
    map['enabled'] = product.enabled;
    map['details'] = product.details;
    return map;
  }

  @override
  String toString() => 'Product{id: $id, source: $source, enabled: $enabled}';
}
