import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

class SettingsVersionStatusText extends StatelessWidget {
  final PackageInfo packageInfo;

  const SettingsVersionStatusText({
    Key? key,
    required this.packageInfo,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    Version? _latestVersion;

    try {
      if (AppConfig.instance.config.appVersion.isNullOrEmpty()) {
        return Text('');
      }

      _latestVersion = getAppVersion(AppConfig.instance.config.appVersion);

      if (packageInfo.version == 'unknown') {
        return Text('');
      }

      if (needsAppUpdate(_latestVersion.toString(), packageInfo.version)) {
        return GestureDetector(
          onTap: () => _showAppUpdateDialog(context),
          child: Text(
            AppLocalizations.of(context)!.updateAvailable,
            style: TextStyle(
              color: AppTheme.warningColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      } else if (isAppBeta(_latestVersion.toString(), packageInfo.version)) {
        return Text(
          AppLocalizations.of(context)!.beta,
          style: TextStyle(
            color: AppTheme.infoColor,
            fontWeight: FontWeight.w700,
          ),
        );
      }

      return Text(
        AppLocalizations.of(context)!.latest,
        style: TextStyle(
          color: AppTheme.successColor,
          fontWeight: FontWeight.w700,
        ),
      );
    } on FormatException {
      return Text('');
    }
  }

  _showAppUpdateDialog(
    BuildContext context,
  ) async =>
      await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AppUpdateDialog(
          packageInfo: packageInfo,
          appVersion: AppConfig.instance.config.appVersion,
        ),
      );
}
