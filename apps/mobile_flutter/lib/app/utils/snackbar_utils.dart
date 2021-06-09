import 'package:flutter/material.dart';
import 'package:flutter_weather/enums/message_type.dart';

void showSnackbar(
  BuildContext context,
  String message, {
  MessageType messageType: MessageType.success,
}) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: messageType.color.withOpacity(0.9),
        ),
      );
