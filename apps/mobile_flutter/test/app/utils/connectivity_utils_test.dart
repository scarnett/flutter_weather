import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'connectivity_utils_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  test('Should NOT have connectivity', () async {
    final MockClient client = MockClient();

    expect(
      await hasConnectivity(
        client: client,
        config: Config.mock(),
        result: ConnectivityResult.none,
      ),
      false,
    );
  });

  test('Should NOT have connectivity', () async {
    final MockClient client = MockClient();

    when(
      client.get(
          Uri.parse('http://flutter-weather.mock/http-connectivity-status')),
    ).thenAnswer((_) async => Response('', 404));

    expect(
      await hasConnectivity(
        client: client,
        config: Config.mock(),
        result: ConnectivityResult.wifi,
      ),
      false,
    );
  });

  test('Should NOT have connectivity', () async {
    final MockClient client = MockClient();

    when(
      client.get(
          Uri.parse('http://flutter-weather.mock/http-connectivity-status')),
    ).thenAnswer((_) async => Response('', 500));

    expect(
      await hasConnectivity(
        client: client,
        config: Config.mock(),
        result: ConnectivityResult.mobile,
      ),
      false,
    );
  });

  test('Should have connectivity', () async {
    final MockClient client = MockClient();

    when(
      client.get(
          Uri.parse('http://flutter-weather.mock/http-connectivity-status')),
    ).thenAnswer((_) async => Response('ok', 200));

    expect(
      await hasConnectivity(
        client: client,
        config: Config.mock(),
        result: ConnectivityResult.mobile,
      ),
      true,
    );
  });

  test('Should have connectivity', () async {
    final MockClient client = MockClient();

    when(
      client.get(
          Uri.parse('http://flutter-weather.mock/http-connectivity-status')),
    ).thenAnswer((_) async => Response('ok', 200));

    expect(
      await hasConnectivity(
        client: client,
        config: Config.mock(),
        result: ConnectivityResult.wifi,
      ),
      true,
    );
  });
}
