import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  DateTime get timeOnly => DateTime(0, 0, 0, hour, minute, second);

  String get dateText => DateFormat('yyyy-MM-dd').format(this);

  String get timeText => DateFormat('hh:mm a').format(this);

  bool isEqualOrBefore(DateTime date) {
    return dateOnly.isAtSameMomentAs(date.dateOnly) || dateOnly.isBefore(date.dateOnly);
  }

  bool isEqualOrAfter(DateTime date) {
    return dateOnly.isAtSameMomentAs(date.dateOnly) || dateOnly.isAfter(date.dateOnly);
  }
}
