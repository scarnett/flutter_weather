import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyView extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => PrivacyPolicyView());

  PrivacyPolicyView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PrivacyPolicyPageViewState();
}

class _PrivacyPolicyPageViewState extends State<PrivacyPolicyView>
    with TickerProviderStateMixin {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).privacyPolicy),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              initialUrl: EnvConfig.PRIVACY_POLICY_URL,
              onWebViewCreated: _onWebViewCreated,
            ),
          ],
        ),
      );

  void _onWebViewCreated(
    WebViewController webViewController,
  ) =>
      _controller.complete(webViewController);
}
