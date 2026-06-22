import 'package:flutter/material.dart';

import '../../constants/report_category_enum.dart';
import '../../constants/report_status_enum.dart';
import '../../utils/text_style/app_text_style.dart';
import '../chip/due_action_chip.dart';
import '../chip/report_category_icon_chip.dart';
import '../chip/report_status_chip.dart';
import '../loading/shimmer_widget.dart';

class ReportCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String timeAgo;
  final ReportStatus status;
  final ReportCategory category;
  final VoidCallback onTap;
  final bool isVideo;
  final DateTime? deadlineDate;

  const ReportCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.timeAgo,
    required this.status,
    required this.category,
    required this.onTap,
    this.isVideo = false,
    this.deadlineDate,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imageUrl.startsWith('http')
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            frameBuilder:
                                (
                                  context,
                                  child,
                                  frame,
                                  wasSynchronouslyLoaded,
                                ) {
                                  if (wasSynchronouslyLoaded || frame != null) {
                                    return child;
                                  }
                                  return ShimmerWidget();
                                },
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: color.surfaceContainerHighest),
                          )
                        : Image.asset(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(color: color.surfaceContainerHighest),
                          ),
                  ),
                  if (isVideo)
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ReportStatusChip.solid(status),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.s16(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 16,
                                color: color.secondary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  location,
                                  style: AppTextStyle.s12(
                                    color: color.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: color.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                timeAgo,
                                style: AppTextStyle.s12(
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          if (status == ReportStatus.action &&
                              deadlineDate != null) ...[
                            const SizedBox(height: 12),
                            DueActionChip(deadlineDate),
                          ],
                        ],
                      ),
                    ),
                    ReportCategoryIconChip(category),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
