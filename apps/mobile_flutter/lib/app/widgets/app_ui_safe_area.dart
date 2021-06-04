import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUiSafeArea extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final Widget? topWidget;
  final Widget? bottomWidget;

  const AppUiSafeArea({
    Key? key,
    required this.child,
    this.top: true,
    this.bottom: true,
    this.topWidget,
    this.bottomWidget,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (top) SizedBox(height: MediaQuery.of(context).padding.top),
          ((topWidget == null) && (bottomWidget == null))
              ? child
              : Expanded(
                  child: Stack(
                    children: <Widget>[
                      child,
                      if (topWidget != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: topWidget,
                        ),
                      if (bottomWidget != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: bottomWidget,
                        ),
                    ],
                  ),
                ),
          if (bottom) SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      );
}
