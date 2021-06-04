import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';

class SettingsOpenSourceInfo extends StatelessWidget {
  const SettingsOpenSourceInfo({
    Key? key,
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
                onTap: () async =>
                    await launchURL(AppConfig.instance.githubUrl),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    _getGitHubImagePath(context),
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ),
            ),
          Expanded(
            child: InkWell(
              onTap: () async => await launchURL('https://flutter.dev/'),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FlutterLogo(size: 50.0),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () async => await launchURL('https://opensource.org/'),
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

  String _getGitHubImagePath(
    BuildContext context,
  ) =>
      (context.read<AppBloc>().state.themeMode == ThemeMode.light)
          ? 'assets/images/github_dark.png'
          : 'assets/images/github_light.png';
}
