import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
import 'package:http/http.dart';
import 'package:sentry/sentry.dart';

class SettingsPushNotificationPicker extends StatefulWidget {
  final PushNotification? selectedNotification;
  final Map<String, dynamic>? selectedNotificationExtras;

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
          ..._buildListOfNotificationTile(PushNotification.off),
          ..._buildListOfNotificationTile(
            PushNotification.currentLocation,
            showDivider: false,
          ),
          ..._buildListOfForecasts(state),
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
        _buildListOfNotificationTile(
          PushNotification.savedLocation,
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
    Map<String, dynamic>? notificationExtras;

    switch (notification) {
      case PushNotification.savedLocation:
        if (!await requestPushNotificationPermission()) {
          break;
        }

        if (forecast != null) {
          notificationExtras = {
            'location': {
              'id': forecast.id,
              'name': forecast.getLocationText(),
              'cityName': forecast.city?.name,
              'country': forecast.city?.country,
              'longitude': forecast.city?.coord?.lon,
              'latitude': forecast.city?.coord?.lat,
            },
          };
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
            Response forecastResponse = await fetchCurrentForecastByCoords(
              client: Client(),
              longitude: position.longitude,
              latitude: position.latitude,
            );

            if (forecastResponse.statusCode == 200) {
              Forecast forecast =
                  Forecast.fromJson(jsonDecode(forecastResponse.body));

              notificationExtras = {
                'location': {
                  'name': forecast.getLocationText(),
                  'cityName': forecast.city?.name,
                  'country': forecast.city?.country,
                  'longitude': forecast.city?.coord?.lon,
                  'latitude': forecast.city?.coord?.lat,
                },
              };
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

  Color? _getNotificationColor(
    PushNotification notification, {
    String? objectId,
  }) {
    if (widget.selectedNotification?.getInfo()!['id'] ==
        notification.getInfo()!['id']) {
      if ((widget.selectedNotificationExtras != null) &&
          widget.selectedNotificationExtras!.containsKey('location')) {
        String? forecastId =
            widget.selectedNotificationExtras?['location']['id'];

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
