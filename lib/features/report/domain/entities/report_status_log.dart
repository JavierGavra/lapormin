import 'package:equatable/equatable.dart';

import '../../../../core/constants/report_status_enum.dart';

class ReportStatusLog extends Equatable {
  final int id;
  final String? userId;
  final ReportStatus status;
  final DateTime createdAt;

  const ReportStatusLog({
    required this.id,
    this.userId,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, status, createdAt];
}
