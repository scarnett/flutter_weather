import 'package:flutter_weather/app/utils/common_utils.dart';
import 'package:version/version.dart';

String scrubVersion(
  String? version,
) {
  if (version.isNullOrEmpty()) {
    return '';
  }

  String scrubbedVersion = version!.replaceAll(RegExp(r'[^0-9.+]'), '');
  return scrubbedVersion;
}

Version? getAppVersion(
  String? appVersion,
) {
  if (appVersion.isNullOrEmpty()) {
    return null;
  }

  String scrubbedVersion = scrubVersion(appVersion);
  Version parsedVersion;

  if (scrubbedVersion.contains('+')) {
    parsedVersion = Version.parse(scrubbedVersion.split('+')[0]);
  } else {
    parsedVersion = Version.parse(scrubbedVersion);
  }

  return parsedVersion;
}

bool needsAppUpdate(
  String? appVersion,
  String? packageVersion,
) {
  if (appVersion.isNullOrEmpty() || packageVersion.isNullOrEmpty()) {
    return true;
  }

  Version parsedAppVersion = Version.parse(appVersion);
  Version parsedPackageVersion = Version.parse(packageVersion);
  return (parsedAppVersion > parsedPackageVersion);
}

bool isAppBeta(
  String appVersion,
  String packageVersion,
) {
  if (appVersion.isNullOrEmpty() || packageVersion.isNullOrEmpty()) {
    return false;
  }

  Version parsedAppVersion = Version.parse(appVersion);
  Version parsedPackageVersion = Version.parse(packageVersion);
  return (parsedPackageVersion > parsedAppVersion);
}
