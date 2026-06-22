import 'package:flutter/material.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

enum InformationCardType { normal, warning, danger }

class InformationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final InformationCardType? type;

  const InformationCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.type = InformationCardType.normal,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    late final Color? backgroundColor, foregroundColor, borderColor;

    switch (type) {
      case InformationCardType.warning:
        backgroundColor = color.warningContainer;
        foregroundColor = color.onWarningContainer;
        borderColor = color.warning;
      case InformationCardType.danger:
        backgroundColor = color.errorContainer;
        foregroundColor = color.onErrorContainer;
        borderColor = color.error;
      case InformationCardType.normal:
      default:
        backgroundColor = color.surfaceContainer;
        foregroundColor = color.onSurface;
        borderColor = color.onSurface;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              if (icon != null) Icon(icon, size: 16, color: foregroundColor),

              Text(
                title.toUpperCase(),
                style: AppTextStyle.s12(
                  fontWeight: FontWeight.w500,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
          Text(
            description,
            style: AppTextStyle.s14(color: color.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
