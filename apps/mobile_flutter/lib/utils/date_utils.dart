import 'package:intl/intl.dart';

extension DateHelpers on DateTime {
  bool isToday() {
    final DateTime now = getNow();
    return (now.day == this.day) &&
        (now.month == this.month) &&
        (now.year == this.year);
  }
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

DateTime? fromIso8601String(String? date) {
  if (date == null) {
    return null;
  }

  return DateTime.parse(date).toUtc();
}

String? formatDateTime(
  DateTime? date,
  String? format,
) {
  if ((date == null) || (format == null)) {
    return null;
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
  String? month = formatDateTime(dateTime, 'MMM');
  String day = formatDateTime(dateTime, 'd')!;
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
