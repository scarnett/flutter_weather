import 'package:intl/intl.dart';

extension DateHelpers on DateTime {
  bool isToday() {
    final DateTime now = getNow();
    return (now.day == this.day) &&
        (now.month == this.month) &&
        (now.year == this.year);
  }

  DateTime startOfDay() => DateTime(this.year, this.month, this.day, 0, 0, 0);

  DateTime endOfToday() =>
      DateTime(this.year, this.month, this.day, 23, 59, 59);

  DateTime endOfDay() =>
      this.getDate().add(Duration(days: 1)).subtract(Duration(seconds: 1));

  DateTime startOfWeek({
    bool isMondayFirstDay: false,
  }) =>
      this
          .getDate()
          .subtract(Duration(days: this.weekday - (isMondayFirstDay ? 1 : 0)))
          .startOfDay();

  DateTime endOfWeek({
    bool isMondayFirstDay: false,
  }) {
    DateTime lastDayOfWeek = this.add(Duration(
        days: (DateTime.daysPerWeek -
            this.weekday -
            (isMondayFirstDay ? 0 : 1))));

    return lastDayOfWeek.endOfDay();
  }

  DateTime startOfMonth() => DateTime(this.year, this.month, 1).startOfDay();

  DateTime endOfMonth() {
    // Providing a day value of zero for the next month
    // gives you the previous month's last day
    DateTime lastDayOfMonth = DateTime(this.year, (this.month + 1), 0);
    return lastDayOfMonth.endOfDay();
  }

  DateTime getDate() => DateTime(this.year, this.month, this.day);
}

DateTime getNow() {
  final DateTime now = DateTime.now().toUtc();
  return now;
}

DateTime getToday() {
  final DateTime now = getNow();
  final DateTime today = DateTime(now.year, now.month, now.day);
  return today;
}

DateTime getTomorrow() {
  final DateTime now = getNow();
  final DateTime tomorrow = DateTime(now.year, now.month, (now.day + 1));
  return tomorrow;
}

DateTime getDaysAgo(
  int days,
) {
  final DateTime now = getNow();
  final DateTime date =
      DateTime(now.year, now.month, now.day).subtract(Duration(days: days));
  return date;
}

DateTime getFirstDayOfWeek() {
  final DateTime today = getToday();
  return today.subtract(Duration(days: today.weekday));
}

DateTime getLastDayOfWeek({
  int offset = 1,
}) {
  final DateTime today = getToday();
  final DateTime lastDayOfWeek = today
    ..add(Duration(days: (DateTime.sunday - today.weekday)));
  return DateTime(
      lastDayOfWeek.year, lastDayOfWeek.month, (lastDayOfWeek.day + offset));
}

String? toIso8601String(
  DateTime? date,
) {
  if (date == null) {
    return null;
  }

  return date.toIso8601String();
}

DateTime? fromIso8601String(
  String? date,
) {
  if (date == null) {
    return null;
  }

  return DateTime.parse(date).toUtc();
}

DateTime? fromString(
  String? date,
) {
  print(date);
  if (date == null) {
    return null;
  }

  return DateTime.parse(date);
}

String? formatDateTime({
  DateTime? date,
  String? format,
  bool addSuffix: false,
}) {
  if ((date == null) || (format == null)) {
    return null;
  }

  if (addSuffix) {
    String day = formatDateTime(date: date, format: 'd')!;
    String suffix = getDaySuffix(int.parse(day));
    return '${DateFormat(format).format(date)}$suffix';
  }

  return DateFormat(format).format(date);
}

String? getDateFormat(
  DateTime? date,
) {
  if (date == null) {
    return null;
  }

  String dateFormat;
  DateTime now = DateTime.now();
  DateTime lastMidnight = DateTime(now.year, now.month, now.day);
  if (date.isBefore(lastMidnight)) {
    dateFormat = 'M/d/yy \'at\' hh:mm a';
  } else {
    dateFormat = 'hh:mm a';
  }

  return dateFormat;
}

DateTime epochToDateTime(
  int epoch,
) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
  return date;
}

String getMonthDay(
  DateTime dateTime,
) {
  String? month = formatDateTime(date: dateTime, format: 'MMM');
  String day = formatDateTime(date: dateTime, format: 'd')!;
  String suffix = getDaySuffix(int.parse(day));
  return '$month $day$suffix';
}

String getDaySuffix(
  int day,
) {
  if (!((day >= 1) && (day <= 31))) {
    throw Exception('Invalid day of month');
  }

  if ((day >= 11) && (day <= 13)) {
    return 'th';
  }

  switch (day % 10) {
    case 1:
      return 'st';

    case 2:
      return 'nd';

    case 3:
      return 'rd';

    default:
      return 'th';
  }
}
