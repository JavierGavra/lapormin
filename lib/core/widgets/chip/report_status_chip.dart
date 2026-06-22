import 'package:flutter/material.dart';

import '../../constants/report_status_enum.dart';
import '../../utils/text_style/app_text_style.dart';
import 'app_chip.dart';

class ReportStatusChip extends StatelessWidget {
  final ReportStatus status;
  final bool isSolid;

  const ReportStatusChip(this.status, {super.key}) : isSolid = false;

  const ReportStatusChip.solid(this.status, {super.key}) : isSolid = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AppChip(
      backgroundColor: isSolid
          ? color.surface
          : status.getColor(context).containerColor.withValues(alpha: 0.5),
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
