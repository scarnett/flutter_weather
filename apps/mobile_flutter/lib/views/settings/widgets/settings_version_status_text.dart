import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/version_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class SettingsVersionStatusText extends StatelessWidget {
  final AppBloc bloc;
  final PackageInfo packageInfo;

  const SettingsVersionStatusText({
    Key key,
    @required this.bloc,
    @required this.packageInfo,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    Version _latestVersion;

    try {
      String _appVersion = bloc.state.appVersion;
      if (_appVersion.isNullOrEmpty()) {
        return Text('');
      } else {
        _latestVersion = getAppVersion(_appVersion);
      }

      if (packageInfo.version == 'unknown') {
        return Text('');
      }

      if (needsAppUpdate(_latestVersion.toString(), packageInfo.version)) {
        return Text(
          AppLocalizations.of(context).updateAvailable,
          style: TextStyle(
            color: AppTheme.warningColor,
            fontWeight: FontWeight.w700,
          ),
        );
      } else if (isAppBeta(_latestVersion.toString(), packageInfo.version)) {
        return Text(
          AppLocalizations.of(context).beta,
          style: TextStyle(
            color: AppTheme.infoColor,
            fontWeight: FontWeight.w700,
          ),
        );
      }

      return Text(
        AppLocalizations.of(context).latest,
        style: TextStyle(
          color: AppTheme.successColor,
          fontWeight: FontWeight.w700,
        ),
      );
    } on FormatException {
      return Text('');
    }
  }
}
