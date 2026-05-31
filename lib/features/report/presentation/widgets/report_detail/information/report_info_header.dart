import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class ReportInfoHeader extends StatelessWidget {
  final String title;
  final DateTime createdAt;
  final ReportCategory category;

  const ReportInfoHeader({
    super.key,
    required this.title,
    required this.createdAt,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      spacing: 8,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.s24(fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: category.getColor(context).containerColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                category.icon,
                size: 18,
                color: category.getColor(context).onContainerColor,
              ),
            ),
          ],
        ),

        // Created at
        Row(
          spacing: 6,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: color.onSurfaceVariant,
            ),
            Text(
              DateFormat("dd MMMM yyyy - HH:mm", 'id_ID').format(createdAt),
              // "${createdAt.day.toString().padLeft(2, '0')} ${createdAt.month.toString().padLeft(2, '0')} ${createdAt.year} - ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}",
              style: AppTextStyle.s14(
                fontWeight: FontWeight.w500,
                color: color.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
