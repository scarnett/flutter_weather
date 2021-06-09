import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyView extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => PrivacyPolicyView());

  PrivacyPolicyView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyPageViewState();
}

class _PrivacyPolicyPageViewState extends State<PrivacyPolicyView>
    with TickerProviderStateMixin {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.privacyPolicy),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: AppUiSafeArea(
            child: Expanded(
              child: Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: AppConfig.instance.config.privacyPolicyUrl,
                    onWebViewCreated: _onWebViewCreated,
                  ),
                ],
              ),
            ),
          ),
          extendBody: true,
          extendBodyBehindAppBar: true,
        ),
      );

  void _onWebViewCreated(
    WebViewController webViewController,
  ) =>
      _controller.complete(webViewController);
}
