import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_theme.dart';

class AppAlert extends StatefulWidget {
  final String title;
  final String bodyText;
  final String buttonText;
  final Image? image;

  const AppAlert({
    Key? key,
    required this.title,
    required this.bodyText,
    required this.buttonText,
    this.image,
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
        elevation: 0.0,
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
            margin: EdgeInsets.only(top: 50.0),
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
                  style: TextStyle(
                    color: AppTheme.secondaryColor.withOpacity(0.7),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    widget.bodyText,
                    style: TextStyle(
                      color: AppTheme.secondaryColor.withOpacity(0.7),
                      fontSize: 22.0,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(widget.buttonText),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      backgroundColor: AppTheme.primaryColor,
                      primary: Colors.white,
                      onSurface: AppTheme.disabledTextColor,
                      minimumSize: Size(100, 10),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            child: widget.image ??
                Image.asset(
                  'assets/images/logo.png',
                  height: 100.0,
                  width: 100.0,
                ),
          ),
        ],
      );
}
