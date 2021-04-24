enum UpdatePeriod {
  HOUR1,
  HOUR2,
  HOUR3,
  HOUR4,
  HOUR5,
}

extension UpdatePeriodExtension on UpdatePeriod {
  Map<String, dynamic>? get info {
    switch (this) {
      case UpdatePeriod.HOUR1:
        return {
          'id': '1hr',
          'text': '1 hour', // TODO!
          'minutes': 60,
        };

      case UpdatePeriod.HOUR2:
        return {
          'id': '2hrs',
          'text': '2 hours', // TODO!
          'minutes': 120,
        };

      case UpdatePeriod.HOUR3:
        return {
          'id': '3hrs',
          'text': '3 hours', // TODO!
          'minutes': 180,
        };

      case UpdatePeriod.HOUR4:
        return {
          'id': '4hrs',
          'text': '4 hours', // TODO!
          'minutes': 240,
        };

      case UpdatePeriod.HOUR5:
        return {
          'id': '5hrs',
          'text': '5 hours', // TODO!
          'minutes': 300,
        };

      default:
        return null;
    }
  }
}
