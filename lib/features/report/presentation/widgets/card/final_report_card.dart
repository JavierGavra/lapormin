import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/domain/entities/final_report.dart';

class FinalReportCard extends StatelessWidget {
  final FinalReport finalReport;

  const FinalReportCard({super.key, required this.finalReport});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.successContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.success),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(
                Icons.description_outlined,
                size: 16,
                color: color.onSuccessContainer,
              ),

              Text(
                "Laporan Akhir".toUpperCase(),
                style: AppTextStyle.s12(
                  fontWeight: FontWeight.w500,
                  color: color.onSuccessContainer,
                ),
              ),
            ],
          ),
          Text(
            finalReport.description,
            style: AppTextStyle.s14(color: color.onSurfaceVariant),
          ),
          _buildFooter(color),
        ],
      ),
    );
  }

  Widget _buildFooter(ColorScheme color) {
    return Row(
      spacing: 4,
      children: [
        Icon(
          Icons.format_quote_outlined,
          size: 16,
          color: color.onPrimaryContainer,
        ),
        Text(
          'Hanya Baca • ${DateFormat('dd MMMM yyyy', 'id_ID').format(finalReport.createdAt)}',
          style: AppTextStyle.s12(
            color: color.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
