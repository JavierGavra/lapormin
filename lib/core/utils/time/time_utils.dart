import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String get currentDaylight {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      return "Pagi";
    } else if (hour >= 12 && hour < 15) {
      return "Siang";
    } else if (hour >= 15 && hour < 18) {
      return "Sore";
    } else {
      return "Malam";
    }
  }

  static Icon get currentDaylightIcon {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 12) {
      return Icon(Icons.sunny_snowing, color: Color(0xffFDA26B));
    } else if (hour >= 12 && hour < 15) {
      return Icon(Icons.sunny, color: Colors.amber);
    } else if (hour >= 15 && hour < 18) {
      return Icon(Icons.work_history_rounded, color: Color(0xffD04F96));
    } else {
      return Icon(Icons.nights_stay_rounded, color: Color(0xff5F5F9A));
    }
  }

  static String get currentDate {
    final x = DateFormat('EEEE, d MMMM y', "id_ID").format(DateTime.now());
    return x;
  }
}
