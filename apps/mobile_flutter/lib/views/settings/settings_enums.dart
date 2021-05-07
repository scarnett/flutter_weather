enum UpdatePeriod {
  HOUR1,
  HOUR2,
  HOUR3,
  HOUR4,
  HOUR5,
}

enum PushNotification {
  OFF,
  CURRENT_LOCATION,
  SAVED_LOCATION,
}

extension UpdatePeriodExtension on UpdatePeriod {
  Map<String, dynamic>? get info {
    switch (this) {
      case UpdatePeriod.HOUR1:
        return {
          'id': '1hr',
          'text': '1 hour', // TODO! i18n
          'minutes': 60,
        };

      case UpdatePeriod.HOUR2:
        return {
          'id': '2hrs',
          'text': '2 Hours', // TODO! i18n
          'minutes': 120,
        };

      case UpdatePeriod.HOUR3:
        return {
          'id': '3hrs',
          'text': '3 Hours', // TODO! i18n
          'minutes': 180,
        };

      case UpdatePeriod.HOUR4:
        return {
          'id': '4hrs',
          'text': '4 Hours', // TODO! i18n
          'minutes': 240,
        };

      case UpdatePeriod.HOUR5:
        return {
          'id': '5hrs',
          'text': '5 Hours', // TODO! i18n
          'minutes': 300,
        };

      default:
        return null;
    }
  }
}

extension PushNotificationExtension on PushNotification {
  Map<String, dynamic>? get info {
    switch (this) {
      case PushNotification.CURRENT_LOCATION:
        return {
          'id': 'current_location',
          'text': 'Current Location', // TODO!
        };

      case PushNotification.SAVED_LOCATION:
        return {
          'id': 'saved_location',
          'text': 'Saved Locations', // TODO!
        };

      case PushNotification.OFF:
      default:
        return {
          'id': 'off',
          'text': 'Off', // TODO!
        };
    }
  }

  String? get text {
    switch (this) {
      case PushNotification.SAVED_LOCATION:
        return this.info!['extra']['objectText'];

      case PushNotification.CURRENT_LOCATION:
      case PushNotification.OFF:
        return this.info!['text'];

      default:
        return null;
    }
  }

  String? getExtraValue(String param) {
    switch (this) {
      case PushNotification.SAVED_LOCATION:
        return this.info?['extra'][param];

      case PushNotification.CURRENT_LOCATION:
      case PushNotification.OFF:
      default:
        return null;
    }
  }
}
