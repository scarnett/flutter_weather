import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:flutter_weather/widgets/app_section_header.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsPushNotificationPicker extends StatefulWidget {
  final PushNotification? selectedNotification;
  final Map<String, dynamic>? selectedNotificationExtras;

  final Function(
    PushNotification? notification,
    Map<String, dynamic>? extras,
  ) onTap;

  SettingsPushNotificationPicker({
    Key? key,
    this.selectedNotification,
    this.selectedNotificationExtras,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPushNotificationPickerState();
}

class _SettingsPushNotificationPickerState
    extends State<SettingsPushNotificationPicker> {
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
        colorTheme: (context.watch<AppBloc>().state.colorTheme),
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme ? Brightness.dark : null,
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
  }

  Widget _buildBody() => Column(
        children: <Widget>[
          Expanded(child: _buildListOfNotifications()),
        ],
      );

  Widget _buildListOfNotifications() => ListView(
        children: [
          ..._buildListOfNotificationTile(PushNotification.OFF),
          ..._buildListOfNotificationTile(
            PushNotification.CURRENT_LOCATION,
            showDivider: false,
          ),
          ..._buildListOfForecasts(),
        ],
      );

  List<Widget> _buildListOfForecasts() {
    List<Forecast> forecasts = context.watch<AppBloc>().state.forecasts;
    if (forecasts.isNullOrZeroLength()) {
      return <Widget>[];
    }

    List<Widget> children = <Widget>[];
    children.add(
      AppSectionHeader(
        bloc: context.read<AppBloc>(),
        text: PushNotification.SAVED_LOCATION.info!['text'],
      ),
    );

    for (int i = 0; i < forecasts.length; i++) {
      children.addAll(
        _buildListOfNotificationTile(
          PushNotification.SAVED_LOCATION,
          forecast: forecasts[i],
          showDivider: ((i + 1) < forecasts.length),
        ),
      );
    }

    return children;
  }

  List<Widget> _buildListOfNotificationTile(
    PushNotification notification, {
    Forecast? forecast,
    bool showDivider: true,
  }) {
    String _id = forecast?.id ?? notification.info!['id'];
    List<Widget> children = <Widget>[];

    Map<String, dynamic> notificationExtras = {};
    if (notification == PushNotification.SAVED_LOCATION) {
      notificationExtras['forecast'] = forecast;
    }

    children.add(
      ListTile(
        key: Key(_id),
        title: _notificationTitleText(
          _id,
          (forecast != null)
              ? getLocationText(forecast)
              : notification.info!['text'],
          notification,
        ),
        onTap: () => _tapPushNotification(
          notification,
          extras: notificationExtras,
        ),
      ),
    );

    if (showDivider) {
      children.add(Divider());
    }

    return children;
  }

  Widget _notificationTitleText(
    String id,
    String text,
    PushNotification notification,
  ) =>
      Text(
        text,
        style: Theme.of(context).textTheme.headline5!.copyWith(
              color: _getNotificationColor(notification, objectId: id),
            ),
      );

  void _tapPushNotification(
    PushNotification notification, {
    Map<String, dynamic>? extras,
  }) async {
    closeKeyboard(context);
    widget.onTap(notification, extras);
  }

  Color? _getNotificationColor(
    PushNotification notification, {
    String? objectId,
  }) {
    if (widget.selectedNotification?.info!['id'] == notification.info!['id']) {
      if ((widget.selectedNotificationExtras != null) &&
          widget.selectedNotificationExtras!.containsKey('forecast')) {
        if (widget.selectedNotificationExtras?['forecast'].id == objectId) {
          return AppTheme.primaryColor;
        }
      } else {
        return AppTheme.primaryColor;
      }
    }

    return null;
  }
}
