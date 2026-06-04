import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/report_status_enum.dart';
import '../../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../domain/entities/field_check.dart';
import '../../../../domain/entities/final_report.dart';
import '../../../../domain/entities/report_status_log.dart';
import '../../card/field_check_card.dart';
import '../../card/final_report_card.dart';
import 'active_bubble.dart';

class _StepConfig {
  final String description;
  final IconData icon;

  _StepConfig(this.description, this.icon);
}

class StatusStepItem extends StatelessWidget {
  final ReportStatus status;
  final ReportStatusLog? log;
  final bool isCompleted;
  final bool isActive;
  final bool isLast;
  final DateTime? dueAction;
  final FieldCheck? fieldCheck;
  final FinalReport? finalReport;

  const StatusStepItem({
    super.key,
    required this.status,
    required this.log,
    required this.isCompleted,
    required this.isActive,
    required this.isLast,
    this.dueAction,
    this.fieldCheck,
    this.finalReport,
  });

  _StepConfig get _stepConfig {
    switch (status) {
      case ReportStatus.pending:
        return _StepConfig(
          "Laporan masuk, menunggu penugasan petugas.",
          Icons.access_time_rounded,
        );
      case ReportStatus.fieldCheck:
        return _StepConfig(
          "Petugas sedang melakukan pengecekan.",
          Icons.search_rounded,
        );
      case ReportStatus.verified:
        return _StepConfig(
          log != null
              ? "Laporan valid, menunggu tindak lanjut."
              : "Laporan valid / tidak valid.",
          Icons.check_circle_outline_rounded,
        );
      case ReportStatus.rejected:
        return _StepConfig(
          log != null
              ? "Laporan tidak valid, laporan akan dihapus dalam 7 hari"
              : "Laporan valid / tidak valid.",
          Icons.close_rounded,
        );
      case ReportStatus.action:
        return _StepConfig(
          "Perbaikan sedang dilakukan. ${dueAction != null ? "Estimasi selesai tanggal ${DateFormat('dd MMMM yyyy', 'id_ID').format(dueAction!)}" : ''}",
          Icons.build_outlined,
        );
      case ReportStatus.done:
        return _StepConfig(
          "Laporan telah selesai ditangani.",
          Icons.done_all_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _buildIndicatorColumn(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildContent(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorColumn(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBubble(color),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              margin: const EdgeInsets.symmetric(vertical: 2),
              color: isActive
                  ? color.surfaceContainerHighest
                  : isCompleted
                  ? color.primary
                  : color.surfaceContainerHighest,
            ),
          ),
      ],
    );
  }

  Widget _buildBubble(ColorScheme color) {
    if (isActive) return ActiveBubble(status: status);

    if (isCompleted) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: status == ReportStatus.rejected ? color.error : color.primary,
        ),
        child: Icon(_stepConfig.icon, color: color.onPrimary),
      );
    }

    // Pending
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.surfaceContainerHighest,
      ),
      child: Icon(
        _stepConfig.icon,
        color: color.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            Row(
              spacing: 12,
              children: [
                Text(
                  status.label,
                  style: AppTextStyle.s16(
                    fontWeight: FontWeight.w600,
                    color: color.onSurface.withValues(
                      alpha: isCompleted ? 1 : 0.5,
                    ),
                  ),
                ),
                if (isActive) _buildNowBadge(context),
              ],
            ),
            Text(
              _stepConfig.description,
              style: AppTextStyle.s14(
                color: color.onSurfaceVariant.withValues(
                  alpha: isCompleted ? 1 : 0.5,
                ),
              ),
            ),
          ],
        ),

        // Timestamp
        if (log != null)
          Text(
            DateFormat('dd MMMM yyyy - HH:mm', 'id_ID').format(log!.createdAt),
            style: AppTextStyle.s12(color: color.onSurfaceVariant),
          ),

        // FieldCheck card
        if (fieldCheck != null) FieldCheckCard(fieldCheck: fieldCheck!),

        // FinalReport card
        if (finalReport != null) FinalReportCard(finalReport: finalReport!),
      ],
    );
  }

  Widget _buildNowBadge(BuildContext context) {
    final color = status.getColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.containerColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "Sekarang",
        style: AppTextStyle.s12(
          fontWeight: FontWeight.w500,
          color: color.mainColor,
        ),
      ),
    );
  }
}
