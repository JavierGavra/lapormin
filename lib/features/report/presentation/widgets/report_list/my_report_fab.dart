import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class MyReportFab extends StatelessWidget {
  final VoidCallback onTap;

  const MyReportFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Material(
      color: color.primary,
      borderRadius: BorderRadius.circular(16),
      shadowColor: const Color(0x4C000000),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.assignment, color: color.onPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Laporanku',
                style: AppTextStyle.s16(
                  fontWeight: FontWeight.w500,
                  color: color.onPrimary,
                ).copyWith(letterSpacing: 0.16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
