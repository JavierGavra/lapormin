import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/evidence.dart';

import '../../../../core/constants/report_status_enum.dart';

class ReportSummary extends Equatable {
  final String id;
  final String title;
  final String shortAdddress;
  final String category;
  final Evidence evidence;
  final DateTime createdAt;
  final DateTime? dueAction;
  final ReportStatus status;

  const ReportSummary({
    required this.id,
    required this.title,
    required this.shortAdddress,
    required this.category,
    required this.evidence,
    required this.createdAt,
    required this.status,
    this.dueAction,
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
    dueAction,
  ];
}
