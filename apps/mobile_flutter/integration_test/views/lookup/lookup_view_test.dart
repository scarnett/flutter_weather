import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/main_test.dart' as app;
import 'package:integration_test/integration_test.dart';
import '../../integration_test_utils.dart';

void main() {
  final IntegrationTestWidgetsFlutterBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized()
          as IntegrationTestWidgetsFlutterBinding;

  group('Add location', () {
    testWidgets('Should add a location', (
      WidgetTester tester,
    ) async {
      await app.main();
      await binding.traceAction(() async {
        // Give the app some tinme to finish loading
        await pumpForSeconds(tester, 2);

        // Tap the add 'location' fab
        Finder addLocationFab = find.byKey(Key(AppKeys.addLocationKey));
        await tester.tap(addLocationFab);
        await tester.pumpAndSettle();

        // Find the 'postal code' text field
        Finder locationPostalCodeField =
            find.byKey(Key(AppKeys.locationPostalCodeKey));

        // Tap the 'postal code' text field and enter some text
        await tester.tap(locationPostalCodeField);
        await tester.enterText(locationPostalCodeField, '90210');

        // Find the 'country' text field
        Finder locationCountryField =
            find.byKey(Key(AppKeys.locationCountryKey));

        // Tap the 'country' text field and enter some text
        await tester.tap(locationCountryField);
        await pumpForSeconds(tester, 1);

        // Find the 'lookup' button
        Finder locationCountryFilterField =
            find.byKey(Key(AppKeys.locationCountryFilterKey));

        // Tap the 'country filter' text field and enter some text
        await tester.tap(locationCountryFilterField);
        await tester.enterText(locationCountryFilterField, 'United States');
        await pumpForSeconds(tester, 1);

        // Find the 'US' country tile and tap it
        Finder locationUSCountryTile = find.byKey(Key('US'));
        await tester.tap(locationUSCountryTile);
        await pumpForSeconds(tester, 1);

        // Find the 'lookup' button
        Finder lookupLocationButton =
            find.byKey(Key(AppKeys.locationLookupButtonKey));

        // Tap the 'lookup' button
        await tester.tap(lookupLocationButton);
        await pumpForSeconds(tester, 2);

        // Verify that the 'city' text is returned
        expect(findText('BEVERLY HILLS'), findsOneWidget);
        await tester.pumpAndSettle();

        // Find the 'add this forcast' button
        Finder addThisForecastButton =
            find.byKey(Key(AppKeys.addThisForecastKey));

        // Tap the 'add this forcast' button
        await tester.tap(addThisForecastButton);
        await tester.pumpAndSettle();

        // Verify that the 'success' snackbar text appears
        expect(findText('BEVERLY HILLS'), findsOneWidget);
        expect(findText('Forecast Added'), findsOneWidget);
        await tester.pumpAndSettle();
      });
    });
  });
}
