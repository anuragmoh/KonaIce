import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatsConstant {
  static const ddMMMYYYYDay = 'dd MMM yyyy, EEEE';
  static const ddMMMYYY = 'dd MMM yyyy';
  static const hhmmaa = 'hh : mm aa';
  static const ddMMMYYYYDayhhmmaa = 'dd MMM yyyy, EEEE hh : mm aa';
  static const YYYYMMddhhmm = 'yyyyMMdd_hhmm';
}

class Date {
  static String getTodaysDate({required String formatValue}) {
    return DateFormat(formatValue).format(DateTime.now());
  }

  static String getDateFrom({required DateTime date, required String formatValue}) {
    return DateFormat(formatValue).format(date);
  }

  static String getDateAndTime(){
    return DateFormat(DateFormatsConstant.YYYYMMddhhmm).format(DateTime.now()).toString();
  }


  static String getDateInHrMinSec({required DateTime date}) {
    var diffDate = DateTime.now().difference(date);
    var hrs = diffDate.inHours.toString().padLeft(2, '0');
    var min = (diffDate.inMinutes % 60).toString().padLeft(2, '0');
    var sec = (diffDate.inSeconds % 60).toString().padLeft(2, '0');
    return '$hrs:$min:$sec';
  }

  static DateTime getDateFromTimeStamp({required int timestamp}) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  static String getTimeStampFromDate() {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    return date.millisecondsSinceEpoch.toString();
  }

  static DateTime getStartOfDay({required DateTime date}) {
    return DateTime(date.year, date.month, date.day);
  }

  static String getStartOfDateTimeStamp({required DateTime date}) {
      return getStartOfDay(date: date).millisecondsSinceEpoch.toString();
  }

  static String getEndOfDateTimeStamp({required DateTime date}) {
     int dayComponent = 1;
     int secComponent = -1;
     DateTime endDate = getStartOfDay(date: date).add(Duration(days: dayComponent, seconds: secComponent));
    return endDate.millisecondsSinceEpoch.toString();
  }
}