import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/utils/time/time_utils.dart';

class AdminInfoBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const AdminInfoBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.transparent,
      child: Ink(
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.00, 0.50),
            end: const Alignment(1.00, 0.50),
            colors: [color.secondary, color.primary],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TimeUtils.currentDate,
                  style: AppTextStyle.s20(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Plus Jakarta Sans',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dari masyarakat untuk masyarakat, LaporMin! hadir untuk masyarakat.',
                  style: AppTextStyle.s14(
                    color: color.surfaceContainerHigh,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
