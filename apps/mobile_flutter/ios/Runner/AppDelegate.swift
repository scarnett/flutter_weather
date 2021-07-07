import UIKit
import Flutter
import Firebase
import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ kGADSimulatorID as! String ]
    GADMobileAds.sharedInstance().start(completionHandler: nil)

    GeneratedPluginRegistrant.register(with: self)

    let appListTileFactory = AppListTileNativeAdFactory()
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(self, factoryId: "listTile", nativeAdFactory: appListTileFactory)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
