import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';

class SettingsOption extends StatelessWidget {
  final PageController pageController;
  final String title;
  final String trailingText;
  final int pageIndex;
  final Function()? onTapCallback;

  const SettingsOption({
    Key? key,
    required this.pageController,
    required this.title,
    required this.trailingText,
    this.pageIndex: 1,
    this.onTapCallback,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      ListTile(
        contentPadding: const EdgeInsets.only(left: 16.0, right: 10.0),
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              trailingText,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.chevron_right,
                color: AppTheme.getHintColor(
                  context.read<AppBloc>().state.themeMode,
                )!
                    .withOpacity(0.3),
              ),
            ),
          ],
        ),
        onTap: () async {
          if (onTapCallback != null) {
            onTapCallback!();
          }

          await animatePage(pageController, page: pageIndex);
        },
      );
}
