import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_status_enum.dart';

class ReportSummary extends Equatable {
  final String id;
  final String title;
  final String shortAdddress;
  final String category;
  final String evidence;
  final DateTime createdAt;
  final DateTime dueDate;
  final ReportStatus status;

  const ReportSummary({
    required this.id,
    required this.title,
    required this.shortAdddress,
    required this.category,
    required this.evidence,
    required this.createdAt,
    required this.status,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    shortAdddress,
    category,
    evidence,
    createdAt,
    status,
    dueDate,
  ];
}
