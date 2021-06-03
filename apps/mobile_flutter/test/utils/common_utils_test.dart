import 'package:flutter_weather/app/utils/common_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should be an integer', () {
    expect(isInteger(1), true);
    expect(isInteger(1.0), true);
    expect(isInteger(-1), true);
    expect(isInteger(-1.0), true);
  });

  test('Should NOT be an integer', () {
    expect(isInteger(0.5), false);
    expect(isInteger(1.5), false);
    expect(isInteger(-0.5), false);
    expect(isInteger(-1.5), false);
  });
}
