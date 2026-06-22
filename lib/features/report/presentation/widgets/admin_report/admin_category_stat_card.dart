import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class AdminCategoryStatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color backgroundColor;
  final Color titleColor;
  final VoidCallback onTap;

  const AdminCategoryStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.backgroundColor,
    required this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: backgroundColor.withValues(alpha: 0.60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: ShapeDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Icon(icon, color: titleColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyle.s16(
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count,
                style: AppTextStyle.s12(
                  fontWeight: FontWeight.w500,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
