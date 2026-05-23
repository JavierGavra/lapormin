import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class CreateReportStepHeader extends StatelessWidget {
  final String title;
  final String description;

  const CreateReportStepHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          title,
          style: AppTextStyle.s24(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          description,
          style: AppTextStyle.s14(color: color.onSurfaceVariant),
        ),
      ],
    );
  }
}
