import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/utils/common_utils.dart';

class SettingsOpenSourceInfo extends StatelessWidget {
  final ThemeMode themeMode;

  const SettingsOpenSourceInfo({
    Key? key,
    required this.themeMode,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (AppConfig.instance.githubUrl != null)
            Expanded(
              child: InkWell(
                onTap: () => launchURL(AppConfig.instance.githubUrl),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    (themeMode == ThemeMode.light)
                        ? 'assets/images/github_dark.png'
                        : 'assets/images/github_light.png',
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ),
            ),
          Expanded(
            child: InkWell(
              onTap: () => launchURL('https://flutter.dev/'),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlutterLogo(size: 50.0),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => launchURL('https://opensource.org/'),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/osi.png',
                  width: 50.0,
                  height: 50.0,
                ),
              ),
            ),
          ),
        ],
      );
}
