import 'package:flutter/material.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/image/image_viewer_page.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:lapormin/core/widgets/video/video_player_page.dart';
import 'package:lapormin/features/report/domain/entities/evidence.dart';

class GridReportInfoEvidences extends StatelessWidget {
  final List<Evidence> evidences;

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
                  return _buildEvidenceCard(context, evidence, itemWidth);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceCard(
    BuildContext context,
    Evidence evidence,
    double itemWidth,
  ) {
    final color = Theme.of(context).colorScheme;
    return Hero(
      tag: evidence.previewUrl,
      child: GestureDetector(
        onTap: () {
          Navigate.push(
            context,
            (evidence.isVideo)
                ? VideoPlayerPage.network(
                    tag: evidence.url,
                    title: "Bukti Lapangan",
                    withDownload: true,
                    urlVideo: evidence.url,
                  )
                : ImageViewerPage.network(
                    tag: evidence.url,
                    title: "Bukti Lapangan",
                    withDownload: true,
                    urlImage: evidence.previewUrl,
                  ),
          );
        },
        child: SizedBox(
          width: itemWidth,
          height: itemWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  evidence.previewUrl,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return ShimmerWidget();
                      },
                  errorBuilder: (context, error, stack) => Container(
                    color: color.surfaceContainerHighest,
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: color.outline,
                    ),
                  ),
                ),

                if (evidence.isVideo)
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
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
