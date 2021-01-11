import 'package:flutter/material.dart';

extension Extension on Object {
  bool isNullOrEmpty() => (this == null) || (this == '');

  bool isNullEmptyOrFalse() => (this == null) || (this == '') || !this;

  bool isNullEmptyZeroOrFalse() =>
      (this == null) || (this == '') || !this || (this == 0);
}

String toCamelCase(
  String str,
) {
  String s = str
      .replaceAllMapped(
          RegExp(
              r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
          (Match m) =>
              "${m[0][0].toUpperCase()}${m[0].substring(1).toLowerCase()}")
      .replaceAll(RegExp(r'(_|-|\s)+'), '');
  return s[0].toLowerCase() + s.substring(1);
}

List<Shadow> commonTextShadow({
  color: Colors.black38,
  blurRadius: 1.0,
  xOffset: 1.0,
  yOffset: 1.0,
}) {
  return [
    Shadow(
      color: color,
      blurRadius: blurRadius,
      offset: Offset(xOffset, yOffset),
    ),
  ];
}

class Nullable<T> {
  T _value;

  Nullable(
    this._value,
  );

  T get value => _value;
}
