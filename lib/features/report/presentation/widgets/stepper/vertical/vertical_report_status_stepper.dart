import 'package:flutter/material.dart';
import 'package:lapormin/features/report/domain/entities/report_aggregate.dart';

import '../../../../../../core/constants/report_status_enum.dart';
import '../../../../domain/entities/report_status_log.dart';
import 'status_step_item.dart';

class VerticalReportStatusStepper extends StatelessWidget {
  final ReportAggregate reportAggregate;

  const VerticalReportStatusStepper({super.key, required this.reportAggregate});

  static const List<ReportStatus> _orderedSteps = [
    ReportStatus.pending,
    ReportStatus.fieldCheck,
    ReportStatus.verified, // diganti rejected jika laporan ditolak
    ReportStatus.action,
    ReportStatus.done,
  ];

  // Status yang sudah dicapai berdasarkan log
  Set<ReportStatus> get _completedStatuses {
    return reportAggregate.statusLogs.map((log) => log.status).toSet();
  }

  // Status terakhir = status saat ini
  ReportStatus? get _currentStatus {
    return reportAggregate.report.status;
  }

  // Cek apakah laporan ditolak
  bool get _isRejected => _completedStatuses.contains(ReportStatus.rejected);

  // Steps yang akan ditampilkan — ganti verified → rejected jika ditolak
  List<ReportStatus> get _displayedSteps {
    return _orderedSteps.map((step) {
      if (step == ReportStatus.verified && _isRejected) {
        return ReportStatus.rejected;
      }
      return step;
    }).toList();
  }

  // Cari log berdasarkan status
  ReportStatusLog? _logForStatus(ReportStatus status) {
    try {
      return reportAggregate.statusLogs.lastWhere(
        (log) => log.status == status,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_orderedSteps.length, (index) {
        final status = _displayedSteps[index];
        final isLast = index == _displayedSteps.length - 1;
        final log = _logForStatus(status);
        final isCompleted = log != null;
        final isActive = status == _currentStatus;

        return StatusStepItem(
          status: status,
          log: log,
          isCompleted: isCompleted,
          isActive: isActive,
          isLast: isLast,
          dueAction: _logForStatus(ReportStatus.action) != null
              ? reportAggregate.report.dueDate
              : null,
          fieldCheck: status == ReportStatus.fieldCheck
              ? reportAggregate.fieldCheck
              : null,
          finalReport: status == ReportStatus.done
              ? reportAggregate.finalReport
              : null,
        );
      }),
    );
  }
}
