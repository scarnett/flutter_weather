import 'package:flutter/services.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sentry/sentry.dart';

class IAPService {
  late PurchaserInfo _purchaserInfo;

  IAPService._internal();

  static final IAPService _instance = IAPService._internal();

  static IAPService get instance => _instance;

  Future<void> initialize(
    Flavor flavor,
  ) async {
    await Purchases.setDebugLogsEnabled(flavor == Flavor.dev);
    await Purchases.setup(AppConfig.instance.config.revenueCatApiKey);

    try {
      _purchaserInfo = await Purchases.getPurchaserInfo();
    } on PlatformException catch (exception, stackTrace) {
      print('Unable to initialize iap');
      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  EntitlementInfos get entitlements => _purchaserInfo.entitlements;

  Future<Offerings> get offerings => Purchases.getOfferings();

  PurchaserInfo get products => _purchaserInfo;

  bool get isPremium {
    if (entitlements.all['premium'] != null) {
      return entitlements.all['premium']!.isActive;
    }

    return false;
  }
}
