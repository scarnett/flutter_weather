import 'package:flutter/material.dart';

extension Extension on Color {
  Color darken([
    double amount = 10,
  ]) {
    assert((1 <= amount) && (amount <= 100));
    double calc = (1 - (amount / 100));
    return Color.fromARGB(
      this.alpha,
      (this.red * calc).round(),
      (this.green * calc).round(),
      (this.blue * calc).round(),
    );
  }

  Color brighten([
    double amount = 10,
  ]) {
    assert((1 <= amount) && (amount <= 100));
    double calc = (amount / 100);
    return Color.fromARGB(
      this.alpha,
      this.red + ((255 - this.red) * calc).round(),
      this.green + ((255 - this.green) * calc).round(),
      this.blue + ((255 - this.blue) * calc).round(),
    );
  }

  String toHex({
    bool prefixSymbol: true,
  }) =>
      '${prefixSymbol ? '#' : ''}' +
      '${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
