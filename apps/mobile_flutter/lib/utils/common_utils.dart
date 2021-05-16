import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension ObjectExtension on Object? {
  bool isNullOrEmpty() => (this == null) || (this == '');

  bool isNullEmptyOrFalse() =>
      (this == null) || (this == '') || !(this as bool);

  bool isNullEmptyZeroOrFalse() =>
      (this == null) || (this == '') || !(this as bool) || (this == 0);
}

extension ListExtension on List? {
  bool isNullOrZeroLength() => (this == null) || (this!.length == 0);
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${this.substring(1)}';

  String camelCase() {
    String s = this
        .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match match) =>
              '${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}',
        )
        .replaceAll(
          RegExp(r'(_|-|\s)+'),
          '',
        );

    return s[0].toLowerCase() + s.substring(1);
  }
}

List<Shadow> commonTextShadow({
  color: Colors.black38,
  blurRadius: 1.0,
  xOffset: 1.0,
  yOffset: 1.0,
}) =>
    [
      Shadow(
        color: color,
        blurRadius: blurRadius,
        offset: Offset(xOffset, yOffset),
      ),
    ];

bool isInteger(
  num? value,
) =>
    (value is int) || (value == value!.roundToDouble());

launchURL(
  String? url,
) async {
  if (url == null) {
    throw 'URL is null';
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

animatePage(
  PageController pageController, {
  num page: 0,
  int duration: 150,
  Curve curve: Curves.linear,
}) {
  pageController.animateToPage(
    page as int,
    duration: Duration(milliseconds: duration),
    curve: curve,
  );
}

void closeKeyboard(
  BuildContext context,
) =>
    FocusScope.of(context).unfocus();

class Nullable<T> {
  T _value;

  Nullable(
    this._value,
  );

  T get value => _value;
}
