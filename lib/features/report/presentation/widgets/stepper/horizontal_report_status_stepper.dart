import 'package:flutter/material.dart';

import '../../../../../core/constants/report_status_enum.dart';
import '../../../../../core/utils/text_style/app_text_style.dart';
import '../chip/custom_chip.dart';

class _StepConfig {
  final IconData icon;
  const _StepConfig({required this.icon});
}

class HorizontalReportStatusStepper extends StatelessWidget {
  final ReportStatus currentStatus;
  final DateTime? dueDate;

  const HorizontalReportStatusStepper({
    super.key,
    required this.currentStatus,
    this.dueDate,
  });

  static const Map<ReportStatus, int> _statusStep = {
    ReportStatus.pending: 1,
    ReportStatus.fieldCheck: 2,
    ReportStatus.verified: 3,
    ReportStatus.rejected: 3,
    ReportStatus.action: 4,
    ReportStatus.done: 5,
  };

  static const List<_StepConfig> _steps = [
    _StepConfig(icon: Icons.access_time_rounded),
    _StepConfig(icon: Icons.search_rounded),
    _StepConfig(icon: Icons.check_circle_outline_rounded),
    _StepConfig(icon: Icons.build_outlined),
    _StepConfig(icon: Icons.done_all_rounded),
  ];

  String _calculateDaysRemaining() {
    final remaining = dueDate!.difference(DateTime.now()).inDays;

    return remaining < 0
        ? "Batas waktu telah terlewati"
        : "Selesai dalam $remaining hari lagi";
  }

  int get _currentStepIndex => ((_statusStep[currentStatus] ?? 1) - 1);
  bool get _isRejected => currentStatus == ReportStatus.rejected;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(12),
        color: color.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          _buildHeader(context),
          _buildStepper(color),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final statusColor = currentStatus.getColor(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Status Saat Ini",
          style: AppTextStyle.s14(fontWeight: FontWeight.w600),
        ),
        CustomChip(
          backgroundColor: statusColor.containerColor.withValues(alpha: 0.5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Icon(Icons.circle, size: 10, color: statusColor.mainColor),
              Text(
                currentStatus.label,
                style: AppTextStyle.s12(
                  fontWeight: FontWeight.w500,
                  color: statusColor.mainColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepper(ColorScheme color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_steps.length * 2 - 1, (index) {
        final isDivider = index.isOdd;

        if (isDivider) {
          final isDone = _currentStepIndex * 2 > index;
          return _buildDivider(color, isDone: isDone);
        }

        final stepIndex = index ~/ 2;
        final isDone = stepIndex < _currentStepIndex;
        final isActive = stepIndex == _currentStepIndex;

        final isRejectedStep = _isRejected && stepIndex == 2; // ← fix bug 3

        return _buildStepBubble(
          color,
          icon: _steps[stepIndex].icon,
          isDone: isDone,
          isActive: isActive,
          isRejectedStep: isRejectedStep,
        );
      }),
    );
  }

  Widget _buildStepBubble(
    ColorScheme color, {
    required IconData icon,
    required bool isDone,
    required bool isActive,
    required bool isRejectedStep,
  }) {
    final Color bubbleColor = switch ((isDone || isActive, isRejectedStep)) {
      (true, true) => color.error, // ditolak
      (true, false) => color.primary, // aktif/selesai
      _ => color.surfaceContainerHighest, // pending
    };

    final Color iconColor = (isDone || isActive)
        ? (isRejectedStep ? color.onError : color.onPrimary)
        : color.onSurfaceVariant;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bubbleColor,
        boxShadow: [
          if (isActive)
            BoxShadow(color: bubbleColor.withValues(alpha: 0.3), blurRadius: 5),
        ],
      ),
      child: Icon(icon, size: 20, color: iconColor),
    );
  }

  Widget _buildDivider(ColorScheme color, {bool isDone = false}) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isDone ? color.primary : color.surfaceDim,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Langkah ${_currentStepIndex + 1} dari ${_steps.length}",
          style: AppTextStyle.s12(
            color: color.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),

        if (dueDate != null)
          Text(
            _calculateDaysRemaining(),
            style: AppTextStyle.s12(
              color: color.tertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
