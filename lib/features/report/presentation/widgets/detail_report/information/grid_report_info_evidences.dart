import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class GridReportInfoEvidences extends StatelessWidget {
  final List<String> evidences;

  const GridReportInfoEvidences({super.key, required this.evidences});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    const int crossAxisCount = 3;
    const double gap = 16;
    const double containerPadding = 16;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(containerPadding),
      decoration: BoxDecoration(
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              Icon(
                Icons.video_collection_outlined,
                size: 16,
                color: color.primary,
              ),
              Text(
                "Bukti - Bukti".toUpperCase(),
                style: AppTextStyle.s12(
                  color: color.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth - (gap * (crossAxisCount - 1))) /
                  crossAxisCount;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: evidences.map((evidence) {
                  return SizedBox(
                    width: itemWidth,
                    height: itemWidth,
                    child: Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(evidence),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
