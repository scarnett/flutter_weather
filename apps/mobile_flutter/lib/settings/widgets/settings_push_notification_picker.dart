import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/message_type.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';

class SettingsPushNotificationPicker extends StatefulWidget {
  final PushNotification? selectedNotification;
  final NotificationExtras? selectedNotificationExtras;

  SettingsPushNotificationPicker({
    Key? key,
    this.selectedNotification,
    this.selectedNotificationExtras,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPushNotificationPickerState();
}

class _SettingsPushNotificationPickerState
    extends State<SettingsPushNotificationPicker> {
  bool processing = false;
  bool error = false;

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
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Theme(
          data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
              ? appDarkThemeData
              : appLightThemeData,
          child: Scaffold(
            body: _buildBody(context.watch<AppBloc>().state),
            extendBody: true,
            extendBodyBehindAppBar: true,
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

  Widget _buildBody(
    AppState state,
  ) =>
      ListView(
        children: [
          ..._buildListOfNotificationTiles(PushNotification.off),
          ..._buildListOfNotificationTiles(
            PushNotification.currentLocation,
            showDivider: false,
          ),
          ..._buildListOfForecasts(state),
          ..._buildMessageOptions(state),
        ],
      );

  List<Widget> _buildListOfForecasts(
    AppState state,
  ) {
    List<Forecast> forecasts = context.watch<AppBloc>().state.forecasts;
    if (forecasts.isNullOrZeroLength()) {
      return <Widget>[];
    }

    List<Widget> children = <Widget>[];
    children.add(
      AppSectionHeader(
        text: PushNotification.savedLocation.getInfo(context: context)!['text'],
      ),
    );

    for (int i = 0; i < forecasts.length; i++) {
      children.addAll(
        _buildListOfNotificationTiles(
          PushNotification.savedLocation,
          forecast: forecasts[i],
          showDivider: ((i + 1) < forecasts.length),
        ),
      );
    }

    return children;
  }

  List<Widget> _buildMessageOptions(
    AppState state,
  ) {
    bool pushStatus = (state.pushNotification != PushNotification.off);
    List<Widget> children = <Widget>[];
    children.addAll([
      AppSectionHeader(
        text: AppLocalizations.of(context)!.pushNotificationOptions,
      ),
      AppCheckboxTile(
        title: AppLocalizations.of(context)!.pushNotificationOptionPlaySound,
        checked: ((state.pushNotificationExtras != null) && pushStatus)
            ? state.pushNotificationExtras!.sound ?? false
            : false,
        onTap: pushStatus
            ? (bool? checked) => _tapPlaySoundOption(state, checked ?? true)
            : null,
      ),
      Divider(),
      AppCheckboxTile(
        title: AppLocalizations.of(context)!.pushNotificationOptionShowUnits,
        checked: ((state.pushNotificationExtras != null) && pushStatus)
            ? state.pushNotificationExtras!.showUnits ?? false
            : false,
        onTap: pushStatus
            ? (bool? checked) => _tapShowUnitsOption(state, checked ?? true)
            : null,
      ),
      Divider(),
    ]);

    return children;
  }

  List<Widget> _buildListOfNotificationTiles(
    PushNotification notification, {
    Forecast? forecast,
    bool showDivider: true,
  }) {
    Map<String, dynamic>? notificationInfo =
        notification.getInfo(context: context);

    String _id = forecast?.id ?? notificationInfo!['id'];
    String? subText = notificationInfo!['subText'];
    List<Widget> children = <Widget>[];

    children.add(
      ListTile(
        key: Key('notification_$_id'),
        title: _notificationTitleText(
          _id,
          (forecast != null)
              ? forecast.getLocationText()
              : notificationInfo['text'],
          notification,
        ),
        subtitle: (subText == null)
            ? null
            : Text(
                subText,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontSize: 12.0,
                      color: AppTheme.getHintColor(
                        context.watch<AppBloc>().state.themeMode,
                      ),
                    ),
              ),
        trailing: _notificationTrailingWidget(notification),
        onTap: processing
            ? null
            : () => _tapPushNotification(notification, forecast: forecast),
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
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: _getNotificationColor(notification, objectId: id),
            ),
      );

  Widget? _notificationTrailingWidget(
    PushNotification notification,
  ) {
    switch (notification) {
      case PushNotification.currentLocation:
        if (processing) {
          return SizedBox(
            height: 20.0,
            width: 20.0,
            child: AppProgressIndicator(color: AppTheme.primaryColor),
          );
        } else if (error) {
          return SizedBox(
            height: 20.0,
            width: 20.0,
            child: Icon(Icons.error, color: AppTheme.dangerColor),
          );
        }

        return null;

      default:
        return null;
    }
  }

  void _tapPushNotification(
    PushNotification notification, {
    Forecast? forecast,
  }) async {
    NotificationExtras? notificationExtras =
        context.read<AppBloc>().state.pushNotificationExtras ??
            NotificationExtras(location: null);

    switch (notification) {
      case PushNotification.savedLocation:
        if (!await requestPushNotificationPermission()) {
          break;
        }

        if (forecast != null) {
          notificationExtras = notificationExtras.copyWith(
            location: NotificationLocation(
              id: forecast.id,
              name: forecast.getLocationText(),
              cityName: forecast.city?.name,
              country: forecast.city?.country,
              longitude: forecast.city?.coord?.lon,
              latitude: forecast.city?.coord?.lat,
            ),
          );
        }

        break;

      case PushNotification.currentLocation:
        if (!await requestPushNotificationPermission()) {
          break;
        }

        setState(() => processing = true);

        Position? position = await getPosition();
        if (position != null) {
          try {
            http.Response forecastResponse = await fetchCurrentForecastByCoords(
              client: http.Client(),
              longitude: position.longitude,
              latitude: position.latitude,
            );

            if (forecastResponse.statusCode == 200) {
              Forecast forecast =
                  Forecast.fromJson(jsonDecode(forecastResponse.body));

              notificationExtras = notificationExtras.copyWith(
                location: NotificationLocation(
                  name: forecast.getLocationText(),
                  cityName: forecast.city?.name,
                  country: forecast.city?.country,
                  longitude: forecast.city?.coord?.lon,
                  latitude: forecast.city?.coord?.lat,
                ),
              );
            }

            setState(() => error = false);
          } on Exception catch (exception, stackTrace) {
            setState(() => error = true);
            await Sentry.captureException(exception, stackTrace: stackTrace);
            notificationExtras = widget.selectedNotificationExtras;

            showSnackbar(
              context,
              AppLocalizations.of(context)!.locationFailure,
              messageType: MessageType.danger,
            );
          }
        }

        setState(() => processing = false);
        break;

      default:
        notificationExtras = null;
        setState(() => processing = false);
        break;
    }

    closeKeyboard(context);

    if (!processing && !error) {
      context.read<AppBloc>().add(SetPushNotification(
            context: context,
            pushNotification: notification,
            pushNotificationExtras: notificationExtras,
          ));
    }
  }

  void _tapPlaySoundOption(
    AppState state,
    bool playSound,
  ) async {
    NotificationExtras? notificationExtras = state.pushNotificationExtras
        ?.copyWith(sound: Nullable<bool>(playSound));

    context.read<AppBloc>().add(SetPushNotification(
          context: context,
          pushNotification: context.read<AppBloc>().state.pushNotification,
          pushNotificationExtras: notificationExtras,
        ));
  }

  void _tapShowUnitsOption(
    AppState state,
    bool showUnits,
  ) async {
    NotificationExtras? notificationExtras = state.pushNotificationExtras
        ?.copyWith(showUnits: Nullable<bool>(showUnits));

    context.read<AppBloc>().add(SetPushNotification(
          context: context,
          pushNotification: context.read<AppBloc>().state.pushNotification,
          pushNotificationExtras: notificationExtras,
        ));
  }

  Color? _getNotificationColor(
    PushNotification notification, {
    String? objectId,
  }) {
    if (widget.selectedNotification?.getInfo()!['id'] ==
        notification.getInfo()!['id']) {
      if ((widget.selectedNotificationExtras != null) &&
          widget.selectedNotificationExtras!.location != null) {
        String? forecastId = widget.selectedNotificationExtras?.location?.id;
        if ((forecastId == null) || (forecastId == objectId)) {
          return AppTheme.primaryColor;
        }
      } else {
        return AppTheme.primaryColor;
      }
    }

    return null;
  }
}
