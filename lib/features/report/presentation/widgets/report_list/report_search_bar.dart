import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class ReportSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const ReportSearchBar({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: color.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: color.onSurfaceVariant, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Cari laporan",
                style: AppTextStyle.s14(color: color.onSurfaceVariant),
              ),
            ),
            GestureDetector(
              onTap: onFilterTap,
              child: Icon(
                Icons.filter_alt_outlined,
                color: color.onSurfaceVariant,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
