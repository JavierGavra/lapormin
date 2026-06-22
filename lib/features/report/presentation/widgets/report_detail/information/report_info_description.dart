import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class ReportInfoDescription extends StatelessWidget {
  final String description;

  const ReportInfoDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Text(
          "Detil Laporan",
          style: AppTextStyle.s16(fontWeight: FontWeight.w600),
        ),
        Text(
          description,
          style: AppTextStyle.s14(color: color.onSurfaceVariant),
        ),
      ],
    );
  }
}
