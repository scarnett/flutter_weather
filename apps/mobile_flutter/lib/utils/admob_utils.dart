import 'dart:io';

// TODO!
class AdmobManager {
  static String get appId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_ADMOB_APP_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_ADMOB_APP_ID>';
    }

    throw new UnsupportedError('Unsupported platform');
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_BANNER_AD_UNIT_ID';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    }

    throw new UnsupportedError('Unsupported platform');
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    }

    throw new UnsupportedError('Unsupported platform');
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_REWARDED_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    }

    throw new UnsupportedError('Unsupported platform');
  }
}
