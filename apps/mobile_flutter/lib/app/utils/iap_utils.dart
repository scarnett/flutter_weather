import 'package:flutter_weather/models/models.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

Future<void> purchase(
  Product product,
) async {
  final PurchaseParam purchaseParam =
      PurchaseParam(productDetails: product.details!);

  IAPConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
}

Future<List<ProductDetails>> getProductDetails(
  List<Product>? products,
) async {
  if ((products != null) && products.isNotEmpty) {
    List<String> productIds = [];

    products.forEach((Product product) {
      productIds..add(product.id);
    });

    return InAppPurchase.instance
        .queryProductDetails(productIds.toSet())
        .then((ProductDetailsResponse response) {
      List<ProductDetails> productDetails = [];

      if (response.notFoundIDs.isNotEmpty) {
        // ...
      } else {
        response.productDetails.forEach((ProductDetails details) {
          productDetails..add(details);
        });
      }

      return productDetails;
    });
  }

  return Future<List<ProductDetails>>.value(null);
}

String? getResponseType(
  String? type,
) {
  if (type == null) {
    return null;
  }

  return type.split('.')[1];
}
