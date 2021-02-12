import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_weather/main_test.dart' as app;

void main() {
  // ignore: missing_return
  Future<String> dataHandler(String msg) async {}
  enableFlutterDriverExtension(handler: dataHandler);
  app.main();
}
