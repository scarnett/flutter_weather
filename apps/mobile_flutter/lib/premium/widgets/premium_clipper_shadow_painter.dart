import 'package:flutter/widgets.dart';

class PremiumClipperShadowPainter extends CustomPainter {
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  PremiumClipperShadowPainter({
    required this.shadow,
    required this.clipper,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    Paint paint = shadow.toPaint();
    Path clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(
    CustomPainter oldDelegate,
  ) =>
      true;
}
