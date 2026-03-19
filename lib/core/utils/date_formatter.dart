import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('MMMM dd yyyy').format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }
}

extension DateGrouping on DateTime {
  String get relativeDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(year, month, day);

    if (dateToCheck == today) return "TODAY";
    if (dateToCheck == yesterday) return "YESTERDAY";
    return "${day}/${month}/${year}";
  }
}
