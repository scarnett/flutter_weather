import 'package:flutter_weather/app/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should format an epoch date', () {
    expect(formatEpoch(epoch: 1626386790), '7/15/21 at 05:06 PM');
    expect(formatEpoch(epoch: 1626386790, format: 'M/d/yy'), '7/15/21');
  });
}
