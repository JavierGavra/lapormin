import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/presentation/widgets/chip/custom_chip.dart';

class ReportInfoTags extends StatelessWidget {
  final String ticket;
  final ReportStatus status;

  const ReportInfoTags({super.key, required this.ticket, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      spacing: 8,
      children: [_buildTicketChip(color), _buildStatusChip(context)],
    );
  }

  Widget _buildTicketChip(ColorScheme color) {
    return CustomChip(
      backgroundColor: color.surfaceContainerHighest,
      child: Text(
        "#$ticket",
        style: AppTextStyle.s12(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    return CustomChip(
      backgroundColor: status
          .getColor(context)
          .containerColor
          .withValues(alpha: 0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: status.getColor(context).mainColor,
          ),
          Text(
            status.label,
            style: AppTextStyle.s12(
              fontWeight: FontWeight.w500,
              color: status.getColor(context).mainColor,
            ),
          ),
        ],
      ),
    );
  }
}
