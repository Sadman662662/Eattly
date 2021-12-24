import 'package:intl/intl.dart';

String getFormattedDate(DateTime selectedMonth, int hour) {
  return DateFormat('HH:mm').format(
    DateTime(
      selectedMonth.year,
      selectedMonth.month,
      selectedMonth.day,
      hour,
    ),
  );
}

DateTime addMonthsToMonthDate(DateTime month, int number) {
  return DateTime(month.year, month.month + number, month.day);
}
