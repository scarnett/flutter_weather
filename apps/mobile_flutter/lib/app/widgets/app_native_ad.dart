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

  final Color? backgroundColor;
  final double height;
  final Alignment alignment;

  AppNativeAd({
    Key? key,
    required this.factoryId,
    this.onAdLoaded,
    this.backgroundColor,
    this.height: 64.0,
    this.alignment: Alignment.center,
  }) : super(key: key);

  @override
  _AppNativeAdState createState() => _AppNativeAdState();
}

class _AppNativeAdState extends State<AppNativeAd> {
  String? _nativeUnitId;
  NativeAd? _ad;
  bool _isLoaded = false;
  late AdWidget _adWidget;

  @override
  void initState() {
    _nativeUnitId = AppConfig.instance.config.adMobNativeUnitId;
    if ((_ad == null) && (_nativeUnitId != null)) {
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
      _adWidget = AdWidget(ad: _ad!);
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
      ((_nativeUnitId != null) && (_ad != null) && _isLoaded)
          ? Container(
              color: widget.backgroundColor ?? Colors.black.withOpacity(0.1),
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Stack(
                children: [
                  _buildAd(),
                  _buildCloseButton(),
                ],
              ),
              height: widget.height,
              alignment: widget.alignment,
            )
          : Container();

  Widget _buildAd() => Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
        child: _adWidget,
      );

  Widget _buildCloseButton() => Padding(
        padding: const EdgeInsets.only(right: 2.0, top: 2.0),
        child: GestureDetector(
          onTap: () => context.read<AppBloc>().add(SetShowPremiumInfo(true)),
          child: Align(
            alignment: Alignment.topRight,
            child: const Icon(Icons.close, size: 16.0),
          ),
        ),
      );
}
