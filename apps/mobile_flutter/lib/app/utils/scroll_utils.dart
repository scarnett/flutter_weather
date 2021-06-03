import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

bool isScrolling(
  ScrollController controller,
) =>
    ((controller.offset > controller.position.minScrollExtent) &&
        (controller.offset < controller.position.maxScrollExtent));

bool isAtTop(
  ScrollController controller,
) =>
    (controller.offset == controller.position.minScrollExtent);

bool isAtBottom(
  ScrollController controller,
) =>
    (controller.offset == controller.position.maxScrollExtent);

bool isScrollingDown(
  ScrollController controller,
) =>
    (controller.position.userScrollDirection == ScrollDirection.reverse);

bool isScrollingUp(
  ScrollController controller,
) =>
    (controller.position.userScrollDirection == ScrollDirection.forward);
