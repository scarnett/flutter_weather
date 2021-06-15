import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry/sentry.dart';

class AppNativeAd extends StatefulWidget {
  final String factoryId;
  final Function({
    required Ad ad,
    required bool isLoaded,
  })? onAdLoaded;

  final double height;
  final Alignment alignment;

  AppNativeAd({
    Key? key,
    required this.factoryId,
    this.onAdLoaded,
    this.height: 72.0,
    this.alignment: Alignment.center,
  }) : super(key: key);

  @override
  _AppNativeAdState createState() => _AppNativeAdState();
}

class _AppNativeAdState extends State<AppNativeAd> {
  late String? _nativeUnitId;
  late NativeAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    if (!context.read<AppBloc>().state.isPremium) {
      _nativeUnitId = AppConfig.instance.config.adMobNativeUnitId;
      if (_nativeUnitId != null) {
        _ad = NativeAd(
          adUnitId: _nativeUnitId!,
          factoryId: widget.factoryId,
          request: AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (Ad ad) {
              setState(() => _isLoaded = true);

              if (widget.onAdLoaded != null) {
                widget.onAdLoaded!(ad: ad, isLoaded: _isLoaded);
              }
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) async {
              // ad.dispose();
              await Sentry.captureMessage(
                'Native ad load failed; code: ${error.code}, message: ${error.message}',
                level: SentryLevel.error,
              );
            },
          ),
        );

        _ad!.load();
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      ((_nativeUnitId != null) && (_ad != null))
          ? Container(
              child: AdWidget(ad: _ad!),
              height: widget.height,
              alignment: widget.alignment,
            )
          : Container();
}
