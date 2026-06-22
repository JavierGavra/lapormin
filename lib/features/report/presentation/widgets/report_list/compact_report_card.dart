import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/chip/report_status_chip.dart';

class CompactReportCard extends StatelessWidget {
  final String title;
  final String location;
  final String timeAgo;
  final ReportStatus status;
  final VoidCallback onTap;
  final DateTime? deadlineDate;

  const CompactReportCard({
    super.key,
    required this.title,
    required this.location,
    required this.timeAgo,
    required this.status,
    required this.onTap,
    this.deadlineDate,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: color.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: color.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.s14(fontWeight: FontWeight.w600),
                      ),
                    ),
                    ReportStatusChip(status),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: color.secondary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        location,
                        style: AppTextStyle.s12(color: color.secondary),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: color.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
                      style: AppTextStyle.s12(color: color.onSurfaceVariant),
                    ),
                  ],
                ),

                if (status == ReportStatus.action && deadlineDate != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.error,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: color.onError,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Tenggat: ${DateFormat('d MMM yyyy', 'id_ID').format(deadlineDate!)}',
                          style: AppTextStyle.s12(
                            color: color.onError,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
