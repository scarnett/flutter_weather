import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppUiAppbarGap extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) =>
      SizedBox(
        height: MediaQuery.of(context)
            .padding
            .top, // + AppBar().preferredSize.height
      );
}
