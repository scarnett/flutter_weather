import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_theme.dart';

enum MessageType {
  info,
  success,
  warning,
  danger,
}

extension MessageTypeExtension on MessageType {
  Color get color {
    switch (this) {
      case MessageType.success:
        return AppTheme.successColor;

      case MessageType.warning:
        return AppTheme.warningColor;

      case MessageType.danger:
        return AppTheme.dangerColor;

      case MessageType.info:
      default:
        return AppTheme.infoColor;
    }
  }
}
