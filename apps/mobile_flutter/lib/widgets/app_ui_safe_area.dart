import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUiSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;

  const AppUiSafeArea({
    Key? key,
    this.top: true,
    this.bottom: true,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Column(
        children: [
          if (top) SizedBox(height: MediaQuery.of(context).padding.top),
          child,
          if (bottom) SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      );
}
