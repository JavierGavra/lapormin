import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/chip/report_category_icon_chip.dart';

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
            ReportCategoryIconChip(category),
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
