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

String toIso8601String(
  DateTime date,
) {
  if (date == null) {
    return null;
  }

  return date.toIso8601String();
}

DateTime fromIso8601String(String date) {
  if (date == null) {
    return null;
  }

  return DateTime.parse(date).toUtc();
}

String formatEpoch(
  int epoch,
  String format, {
  isUtc: false,
}) {
  if (epoch == null) {
    return null;
  }

  DateTime date = DateTime.fromMillisecondsSinceEpoch(epoch, isUtc: isUtc);
  return formatDateTime(date, format);
}

String formatDateTime(
  DateTime date,
  String format,
) {
  if ((date == null) || (format == null)) {
    return null;
  }

  return DateFormat(format).format(date);
}

String formatDateStr(
  String dateStr,
  String format,
) {
  if (dateStr == null) {
    return null;
  }

  return formatDateTime(DateTime.parse(dateStr), format);
}

String getDateFormat(
  DateTime date,
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
  DateTime date = DateTime.fromMicrosecondsSinceEpoch(epoch * 1000);
  return date;
}

int dayDiff(
  DateTime date1,
  DateTime date2,
) {
  if ((date1 != null) && (date1 != null)) {
    return date2.difference(date1).inDays;
  }

  return 0;
}
