import 'package:flutter/widgets.dart';

class PremiumClipper extends CustomClipper<Path> {
  @override
  Path getClip(
    Size size,
  ) {
    Path path = Path();
    path.lineTo(0.0, (size.height - 30));

    Offset firstControlPoint = Offset((size.width / 4), size.height);
    Offset firstPoint = Offset((size.width / 2), size.height);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstPoint.dx,
      firstPoint.dy,
    );

    Offset secondControlPoint =
        Offset((size.width - (size.width / 4)), size.height);

    Offset secondPoint = Offset(size.width, (size.height - 30));

    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondPoint.dx,
      secondPoint.dy,
    );

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(
    CustomClipper<Path> oldClipper,
  ) =>
      false;
}
