import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/settings/widgets/settings_enums.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsPushNotificationPicker extends StatefulWidget {
  final PushNotification? selectedNotification;

  final Function(
    PushNotification notification,
  ) onTap;

  SettingsPushNotificationPicker({
    Key? key,
    this.selectedNotification,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPushNotificationPickerState();
}

class _SettingsPushNotificationPickerState
    extends State<SettingsPushNotificationPicker> {
  List<PushNotification>? _notificationList;

  @override
  void initState() {
    super.initState();
    _prepareNotifications();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        themeMode: context.watch<AppBloc>().state.themeMode,
        colorTheme: (context.watch<AppBloc>().state.colorTheme ?? false),
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme! ? Brightness.dark : null,
        child: Theme(
          data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
              ? appDarkThemeData
              : appLightThemeData,
          child: Scaffold(
            extendBody: true,
            body: _buildBody(),
          ),
        ),
      );

  Future<void> _prepareNotifications() async {
    List<PushNotification>? notifications = <PushNotification>[];

    try {
      for (PushNotification notification in PushNotification.values) {
        notifications.add(notification);
      }
    } on PlatformException {
      notifications = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _notificationList = notifications;
    });
  }

  Widget _buildBody() => Column(
        children: <Widget>[
          Expanded(child: _buildListOfNotificationss()),
        ],
      );

  Widget _buildListOfNotificationss() => ListView.separated(
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final PushNotification notification = _notificationList![index];

          return ListTile(
            key: Key('notification_${notification.info!['id']}'),
            title: Text(
              notification.info!['text'],
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: _getNotificationColor(notification),
                  ),
            ),
            onTap: () => _tapPushNotification(notification),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: (_notificationList != null) ? _notificationList!.length : 0,
      );

  void _tapPushNotification(
    PushNotification notification,
  ) async {
    closeKeyboard(context);
    widget.onTap(notification);
  }

  Color? _getNotificationColor(
    PushNotification notification,
  ) {
    if (widget.selectedNotification?.info!['id'] == notification.info!['id']) {
      return AppTheme.primaryColor;
    }

    return null;
  }
}
