import google_mobile_ads

class AppListTileNativeAdFactory : FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView", owner: nil, options: nil)!.first
        let nativeAdView = (nibView as! GADNativeAdView)
        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline

        if let headlineTextColor = customOptions?["headlineTextColor"] {
            (nativeAdView.headlineView as! UILabel).textColor = hexStringToUIColor(hex: headlineTextColor as! String)
        }

        (nativeAdView.bodyView as! UILabel).text = nativeAd.body

        if let bodyTextColor = customOptions?["bodyTextColor"] {
            (nativeAdView.bodyView as! UILabel).textColor = hexStringToUIColor(hex: bodyTextColor as! String)
        }

        nativeAdView.bodyView!.isHidden = (nativeAd.body == nil)
        (nativeAdView.iconView as! UIImageView).image = nativeAd.icon?.image
        nativeAdView.iconView!.isHidden = (nativeAd.icon == nil)
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        nativeAdView.nativeAd = nativeAd
        return nativeAdView
    }

    func hexStringToUIColor (hex: String) -> UIColor {
        var colorHex: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (colorHex.hasPrefix("#")) {
            colorHex.remove(at: colorHex.startIndex)
        }

        if ((colorHex.count) != 6) {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: colorHex).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}