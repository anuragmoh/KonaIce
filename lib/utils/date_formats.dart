import 'package:intl/intl.dart';

class DateFormatsConstant {
  static const ddMMMYYYYDay = 'dd MMM yyyy, EEEE';
}

class Date {
  static String getTodaysDate({required String formatValue}) {
    return DateFormat(formatValue).format(DateTime.now());
  }

  static String getDateInHrMinSec({required DateTime date}) {
    var diffDate = DateTime.now().difference(date);
    var hrs = diffDate.inHours.toString().padLeft(2, '0');
    var min = (diffDate.inMinutes % 60).toString().padLeft(2, '0');
    var sec = (diffDate.inSeconds % 60).toString().padLeft(2, '0');
    return '$hrs:$min:$sec';
  }
}