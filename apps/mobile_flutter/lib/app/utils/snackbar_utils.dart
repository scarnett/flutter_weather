import 'package:flutter/material.dart';
import 'package:flutter_weather/enums/message_type.dart';

void showSnackbar(
  BuildContext context,
  String message, {
  MessageType messageType: MessageType.success,
  Color? textColor: Colors.white,
  Color? backgroundColor,
  double backgroundColorOpacity: 0.9,
  Duration duration: const Duration(milliseconds: 2000),
}) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: textColor)),
          backgroundColor: (backgroundColor == null)
              ? messageType.color.withOpacity(backgroundColorOpacity)
              : backgroundColor.withOpacity(backgroundColorOpacity),
          duration: duration,
        ),
      );
