import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReportCardShimmer extends StatelessWidget {
  const ReportCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: color.surfaceContainerHighest,
            highlightColor: color.surfaceContainer,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.onPrimary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: color.surfaceContainerHighest,
                        highlightColor: color.surfaceContainer,
                        child: Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.onPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Shimmer.fromColors(
                        baseColor: color.surfaceContainerHighest,
                        highlightColor: color.surfaceContainer,
                        child: Container(
                          height: 12,
                          width: 150,
                          decoration: BoxDecoration(
                            color: color.onPrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Shimmer.fromColors(
                  baseColor: color.surfaceContainerHighest,
                  highlightColor: color.surfaceContainer,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
