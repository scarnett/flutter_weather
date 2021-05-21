import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class LargeCustomHeader extends SliverPersistentHeaderDelegate {
  LargeCustomHeader({
    this.children,
    this.childrenHeight = 0,
  });

  final List<Widget>? children;
  final double childrenHeight;
  final double _navBarHeight = 56;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.0)),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children!,
      ),
    );
  }

  @override
  double get maxExtent => _navBarHeight + childrenHeight;

  @override
  double get minExtent => _navBarHeight;

  // @override
  // FloatingHeaderSnapConfiguration get snapConfiguration => FloatingHeaderSnapConfiguration() ;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration(
        stretchTriggerOffset: maxExtent,
        onStretchTrigger: null,
      );

  double get maxShrinkOffset => maxExtent - minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    //TODO: implement specific rebuild checks
    return true;
  }
}
