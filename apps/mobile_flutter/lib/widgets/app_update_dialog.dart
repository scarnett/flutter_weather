import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:package_info/package_info.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateDialog extends StatefulWidget {
  final PackageInfo packageInfo;
  final String appVersion;

  AppUpdateDialog({
    @required this.packageInfo,
    @required this.appVersion,
  });

  @override
  _AppUpdateDialogState createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  @override
  Widget build(
    BuildContext context,
  ) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context).updateAvailable),
        content: Text(AppLocalizations.of(context).getUpdateAvailableText(
          AppLocalizations.appTitle,
          widget.packageInfo.version,
          widget.appVersion,
        )),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context).updateNow),
            onPressed: _tapOpenAppStore,
          ),
          CupertinoDialogAction(
            child: Text(AppLocalizations.of(context).later),
            onPressed: _tapLater,
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(AppLocalizations.of(context).updateAvailable),
      content: Text(AppLocalizations.of(context).getUpdateAvailableText(
        AppLocalizations.appTitle,
        widget.packageInfo.version,
        widget.appVersion,
      )),
      actions: <Widget>[
        AppFormButton(
          text: AppLocalizations.of(context).updateNow,
          onTap: _tapOpenPlayStore,
        ),
        AppFormButton(
          text: AppLocalizations.of(context).later,
          textColor: AppTheme.disabledColor,
          buttonColor: Colors.transparent,
          onTap: _tapLater,
        ),
      ],
    );
  }

  void _tapOpenPlayStore() =>
      StoreRedirect.redirect(androidAppId: widget.packageInfo.packageName);

  void _tapOpenAppStore() =>
      StoreRedirect.redirect(iOSAppId: widget.packageInfo.packageName);

  void _tapLater() => Navigator.pop(context);
}
