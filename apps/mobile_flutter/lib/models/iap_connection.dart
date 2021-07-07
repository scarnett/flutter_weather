import 'package:in_app_purchase/in_app_purchase.dart';

class IAPConnection {
  static InAppPurchase? _instance;

  static set instance(
    InAppPurchase value,
  ) {
    _instance = value;
  }

  static InAppPurchase get instance {
    _instance ??= InAppPurchase.instance;
    return _instance!;
  }
}
