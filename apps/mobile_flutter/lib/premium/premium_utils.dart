import 'package:flutter/material.dart';
import 'package:flutter_weather/models/models.dart';

String getScreenshot(
  Screenshot screenshot, {
  required ThemeMode themeMode,
  bool colorized: false,
}) {
  if (colorized) {
    return screenshot.colorized;
  } else if (themeMode == ThemeMode.light) {
    return screenshot.light;
  }

  return screenshot.dark;
}
