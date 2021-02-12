import 'package:flutter/widgets.dart';
import 'package:flutter_driver/flutter_driver.dart' as fd;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<fd.FlutterDriver> setupAndGetDriver() async {
  fd.FlutterDriver driver = await fd.FlutterDriver.connect();
  bool connected = false;

  while (!connected) {
    try {
      await driver.waitUntilFirstFrameRasterized();
      connected = true;
    } catch (error) {}
  }

  return driver;
}

void main() {
  group('Forecasts', () {
    fd.FlutterDriver driver;

    setUpAll(() async {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      driver = await setupAndGetDriver();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    testWidgets('Add new locaiton', (WidgetTester tester) async {
      // await driver.tap(fab);
      // expect(await driver.getText(counterTextFinder), "1");

      await tester.pumpAndSettle();

      final Finder fab = find.byKey(Key('addLocation'));

      await tester.tap(fab);
      await tester.pumpAndSettle();
    });
  });
}
