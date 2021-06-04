import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_theme.dart';

getInputTextLabelStyle(
  FocusNode focusNode,
) =>
    TextStyle(
      color: focusNode.hasFocus ? AppTheme.primaryColor : Colors.grey[400],
    );
