import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAlert extends StatefulWidget {
  final String title;
  final String description;
  final String text;
  final Image image;

  const AppAlert({
    Key? key,
    required this.title,
    required this.description,
    required this.text,
    required this.image,
  }) : super(key: key);

  @override
  _AppAlertState createState() => _AppAlertState();
}

class _AppAlertState extends State<AppAlert> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _buildContent(),
      );

  Widget _buildContent() => Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 20.0,
              top: 65.0,
              right: 20.0,
              bottom: 20.0,
            ),
            margin: EdgeInsets.only(top: 65.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.0, 10.0),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 22.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      widget.text,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20.0,
            right: 20.0,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 45.0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45.0)),
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
            ),
          ),
        ],
      );
}
