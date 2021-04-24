enum UpdatePeriod {
  HOUR1,
  HOUR2,
  HOUR3,
  HOUR4,
  HOUR5,
}

extension UpdatePeriodExtension on UpdatePeriod {
  String? get id {
    switch (this) {
      case UpdatePeriod.HOUR1:
        return '1hr';

      case UpdatePeriod.HOUR2:
        return '2hrs';

      case UpdatePeriod.HOUR3:
        return '3hrs';

      case UpdatePeriod.HOUR4:
        return '4hrs';

      case UpdatePeriod.HOUR5:
        return '5hrs';

      default:
        return null;
    }
  }

  String? get text {
    switch (this) {
      case UpdatePeriod.HOUR1:
        return '1 hour'; // TODO!

      case UpdatePeriod.HOUR2:
        return '2 hours'; // TODO!

      case UpdatePeriod.HOUR3:
        return '3 hours'; // TODO!

      case UpdatePeriod.HOUR4:
        return '4 hours'; // TODO!

      case UpdatePeriod.HOUR5:
        return '5 hours'; // TODO!

      default:
        return null;
    }
  }
}
