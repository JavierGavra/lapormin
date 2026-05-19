import 'package:flutter/material.dart';

enum ReportStatus {
  pending('pending'),
  verified('verified'),
  fieldCheck('field_check'),
  action('action'),
  done('done'),
  rejected('rejected');

  final String dbValue;
  const ReportStatus(this.dbValue);

  String get label {
    switch (this) {
      case ReportStatus.pending:
        return 'Menunggu';
      case ReportStatus.verified:
        return 'Terverifikasi';
      case ReportStatus.fieldCheck:
        return 'Cek Lapangan';
      case ReportStatus.action:
        return 'Tindakan';
      case ReportStatus.done:
        return 'Selesai';
      case ReportStatus.rejected:
        return 'Ditolak';
    }
  }

  Color get color {
    switch (this) {
      case ReportStatus.pending:
        return const Color(0xff79716F); // outline
      case ReportStatus.verified:
        return const Color(0xff0839A4); // primary
      case ReportStatus.fieldCheck:
        return const Color(0xFFEE9F0A); // warning
      case ReportStatus.action:
        return const Color(0xffB52600); // error
      case ReportStatus.done:
        return const Color(0xFF4BC57C); // success
      case ReportStatus.rejected:
        return const Color(0xff4F4644); // onSurfaceVariant
    }
  }

  // 3. Helper Parsing
  static ReportStatus fromString(String status) {
    return ReportStatus.values.firstWhere(
      (e) => e.dbValue == status,
      orElse: () => ReportStatus.pending,
    );
  }
}
