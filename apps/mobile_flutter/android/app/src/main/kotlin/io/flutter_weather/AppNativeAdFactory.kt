package io.flutter_weather

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin


class AppListTileNativeAdFactory(
  val context: Context,
) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.list_tile_native_ad, null) as NativeAdView

        with(nativeAdView) {
            val iconView = findViewById<ImageView>(R.id.list_tile_native_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                iconView.setImageDrawable(icon.drawable)
            }

            this.iconView = iconView

            val headlineView = findViewById<TextView>(R.id.list_tile_native_ad_headline)
            headlineView.text = nativeAd.headline

            if ((customOptions != null) && customOptions.containsKey("headlineTextColor")) {
                headlineView.setTextColor(parseColor(customOptions.get("headlineTextColor") as String))
            }

            this.headlineView = headlineView

            val bodyView = findViewById<TextView>(R.id.list_tile_native_ad_body)
            with(bodyView) {
                text = nativeAd.body

                if ((customOptions != null) && customOptions.containsKey("bodyTextColor")) {
                    setTextColor(parseColor(customOptions.get("bodyTextColor") as String, 70))
                }

                visibility = if ((nativeAd.body != null) && nativeAd.body!!.trim().isNotEmpty()) View.VISIBLE else View.INVISIBLE
            }

            this.bodyView = bodyView
            setNativeAd(nativeAd)
        }

        return nativeAdView
    }

    fun parseColor(
      color: String,
      opacity: Int? = 100,
    ): Int {
      var newColor: String = ""

      if (color.startsWith("#")) {
        var colorParts: List<String> = color.split("#")
        newColor += "#"

        if (opacity != null) {
          newColor += getOpacityCode(opacity)
        }

        newColor += colorParts[1]
      } else if (opacity != null) {
        newColor += "#"
        newColor += getOpacityCode(opacity)
        newColor += color
      } else {
        newColor += "#"
        newColor += color
      }

      return Color.parseColor(newColor)
    }

    fun getOpacityCode(
      opacity: Int,
    ): String {
      when (opacity) {
        95 -> return "F2"
        90 -> return "E6"
        85 -> return "D9"
        80 -> return "CC"
        75 -> return "BF"
        70 -> return "B3"
        65 -> return "A6"
        60 -> return "99"
        55 -> return "8C"
        50 -> return "80"
        45 -> return "73"
        40 -> return "66"
        35 -> return "59"
        30 -> return "4D"
        25 -> return "40"
        20 -> return "33"
        15 -> return "26"
        10 -> return "1A"
        5 -> return "0D"
        0 -> return "00"
        else -> return "FF"
      }
    }
}
