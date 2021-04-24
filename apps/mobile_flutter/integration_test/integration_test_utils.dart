import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpForSeconds(
  WidgetTester tester,
  int seconds,
) async {
  bool timerDone = false;

  Timer(Duration(seconds: seconds), () => timerDone = true);

  while (timerDone != true) {
    await tester.pump();
  }
}

Finder findText(
  String text,
) =>
    find.byWidgetPredicate(
      (Widget widget) => (widget is Text) && widget.data!.startsWith(text),
    );
