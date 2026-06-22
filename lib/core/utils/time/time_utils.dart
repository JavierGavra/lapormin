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

  static String format(DateTime? dateTime) {
    if (dateTime == null) return '-';

    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();
    final diff = now.difference(localDateTime);

    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(
      localDateTime.year,
      localDateTime.month,
      localDateTime.day,
    );
    final differenceInDays = today.difference(targetDate).inDays;

    final hour = localDateTime.hour.toString().padLeft(2, '0');
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final timeString = '$hour:$minute';

    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    // Kondisi A: Terjadi pada hari yang sama
    if (differenceInDays == 0) {
      if (diff.inMinutes < 60 && diff.inMinutes >= 0) {
        if (diff.inMinutes <= 1) return 'Baru saja';
        return '${diff.inMinutes} menit yang lalu';
      }
      return 'Hari ini, $timeString';
    }
    // Kondisi B: Terjadi kemarin
    else if (differenceInDays == 1) {
      return 'Kemarin, $timeString';
    }
    // Kondisi C: Terjadi di tahun yang sama, tapi lebih dari kemarin
    else if (localDateTime.year == now.year) {
      return '${localDateTime.day} ${months[localDateTime.month]}, $timeString';
    }
    // Kondisi D: Terjadi di tahun sebelumnya
    else {
      return '${localDateTime.day} ${months[localDateTime.month]} ${localDateTime.year}, $timeString';
    }
  }
}
