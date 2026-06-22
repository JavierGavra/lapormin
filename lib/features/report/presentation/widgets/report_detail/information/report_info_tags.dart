import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/chip/app_chip.dart';
import 'package:lapormin/core/widgets/chip/report_status_chip.dart';

class ReportInfoTags extends StatelessWidget {
  final String ticket;
  final ReportStatus status;

  const ReportInfoTags({super.key, required this.ticket, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Row(
      spacing: 8,
      children: [_buildTicketChip(color), ReportStatusChip(status)],
    );
  }

  Widget _buildTicketChip(ColorScheme color) {
    return AppChip(
      backgroundColor: color.surfaceContainerHighest,
      child: Text(
        "#$ticket",
        style: AppTextStyle.s12(fontWeight: FontWeight.w600),
      ),
    );
  }
}
