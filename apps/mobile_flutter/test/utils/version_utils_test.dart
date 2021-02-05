import 'package:flutter_weather/utils/version_utils.dart';
import 'package:test/test.dart';
import 'package:version/version.dart';

void main() {
  test('Should scrub the version', () {
    expect(scrubVersion(null), '');
    expect(scrubVersion(''), '');
    expect(scrubVersion('1.0.0'), '1.0.0');
    expect(scrubVersion('1.0.0+abc123'), '1.0.0+123');
    expect(scrubVersion('1.0.0+00001beta'), '1.0.0+00001');
  });

  test('Should get the app version', () {
    expect(getAppVersion(null), null);
    expect(getAppVersion('1.0.0'), Version(1, 0, 0));
    expect(getAppVersion('1.0.0+abc123'), Version(1, 0, 0));
    expect(getAppVersion('1.0.0+00001beta'), Version(1, 0, 0));
  });

  test('Should need to update app', () {
    expect(needsAppUpdate('1.0.0', null), true);
    expect(needsAppUpdate(null, '1.0.0'), true);
    expect(needsAppUpdate('1.0.0', '0.9.0'), true);
    expect(needsAppUpdate('1.0.0+abc123', '0.9.0'), true);
  });

  test('Should NOT need to update app', () {
    expect(needsAppUpdate('1.0.0', '1.0.0'), false);
    expect(needsAppUpdate('1.0.0', '1.0.1'), false);
    expect(needsAppUpdate('1.0.0+abc123', '1.0.1'), false);
    expect(needsAppUpdate('1.0.0', '99.99.99'), false);
  });

  test('Should be a beta version', () {
    expect(isAppBeta('1.0.0', '1.0.1'), true);
    expect(isAppBeta('1.0.0', '99.99.99'), true);
  });

  test('Should NOT be a beta version', () {
    expect(isAppBeta('1.0.0', '0.9.0'), false);
    expect(isAppBeta('1.0.0', '1.0.0'), false);
  });
}
