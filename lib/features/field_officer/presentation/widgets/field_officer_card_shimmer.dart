import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FieldOfficerCardShimmer extends StatelessWidget {
  const FieldOfficerCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: color.surfaceContainerHighest,
            highlightColor: color.surface,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: color.surfaceContainerHighest,
                  highlightColor: color.surface,
                  child: Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Shimmer.fromColors(
                  baseColor: color.surfaceContainerHighest,
                  highlightColor: color.surface,
                  child: Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color.onPrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          Shimmer.fromColors(
            baseColor: color.surfaceContainerHighest,
            highlightColor: color.surface,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
