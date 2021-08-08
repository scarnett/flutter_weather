import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
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
    this.height: 75.0,
    this.alignment: Alignment.center,
  }) : super(key: key);

  @override
  _AppNativeAdState createState() => _AppNativeAdState();
}

class _AppNativeAdState extends State<AppNativeAd>
    with AutomaticKeepAliveClientMixin {
  String? _nativeUnitId;
  NativeAd? _ad;
  bool _isLoaded = false;

  late ThemeMode _themeMode;
  late AdWidget _adWidget;

  @override
  void initState() {
    AppState state = context.read<AppBloc>().state;
    _themeMode = state.themeMode;
    _nativeUnitId = AppConfig.instance.config.adMobNativeUnitId;
    if ((_ad == null) && (_nativeUnitId != null)) {
      _ad = _buildNativeAd(state);
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
  bool get wantKeepAlive => true;

  @override
  Widget build(
    BuildContext context,
  ) {
    super.build(context);

    return ((_nativeUnitId != null) && (_ad != null) && _isLoaded)
        ? BlocListener<AppBloc, AppState>(
            listener: (
              BuildContext context,
              AppState state,
            ) =>
                _blocListener(context, state),
            child: Container(
              color: widget.backgroundColor ?? Colors.black.withOpacity(0.075),
              margin: const EdgeInsets.only(bottom: 10.0),
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  _adWidget,
                  _buildCloseButton(),
                ],
              ),
              height: widget.height,
              alignment: widget.alignment,
            ),
          )
        : Container();
  }

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (_themeMode != state.themeMode) {
      setState(() {
        _themeMode = state.themeMode;

        if (_ad != null) {
          _ad?.dispose();
          _ad = _buildNativeAd(state);
          _ad!.load();
          _adWidget = AdWidget(ad: _ad!);
        }
      });
    }
  }

  NativeAd _buildNativeAd(
    AppState state,
  ) =>
      NativeAd(
        adUnitId: _nativeUnitId!,
        factoryId: widget.factoryId,
        request: AdRequest(),
        customOptions: {
          'headlineTextColor': AppTheme.getAdmobHeadlineColor(
            state.themeMode,
            colorTheme: state.colorTheme,
          )!
              .toHex(),
          'bodyTextColor': AppTheme.getAdmobBodyColor(
            state.themeMode,
            colorTheme: state.colorTheme,
          )!
              .toHex(),
        },
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
              'Native ad load failed; code: ${error.code}, ' +
                  'message: ${error.message}',
              level: SentryLevel.error,
            );
          },
        ),
      );

  Widget _buildCloseButton() => GestureDetector(
        onTap: () => context.read<AppBloc>().add(SetShowPremiumInfo(true)),
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: const Icon(Icons.close, size: 16.0),
          ),
        ),
      );
}
