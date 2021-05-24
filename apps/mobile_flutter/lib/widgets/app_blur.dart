import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBlur extends StatelessWidget {
  final Widget child;

  const AppBlur({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
            ),
            child: child,
            // child: ShaderMask(
            //   shaderCallback: (Rect rect) => LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Colors.black,
            //         Colors.black.withOpacity(0),
            //       ],
            //       stops: [
            //         0.4,
            //         0.75
            //       ]).createShader(rect),
            //   blendMode: BlendMode.dstOut,
            //   child: child,
            // ),
          ),
        ),
      );
}
