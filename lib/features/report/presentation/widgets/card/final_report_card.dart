import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/image/image_viewer_page.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:lapormin/features/report/domain/entities/final_report.dart';

class FinalReportCard extends StatelessWidget {
  final FinalReport finalReport;

  const FinalReportCard({super.key, required this.finalReport});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.successContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.success),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(
                Icons.description_outlined,
                size: 16,
                color: color.onSuccessContainer,
              ),

              Text(
                "Laporan Akhir".toUpperCase(),
                style: AppTextStyle.s12(
                  fontWeight: FontWeight.w500,
                  color: color.onSuccessContainer,
                ),
              ),
            ],
          ),
          Text(
            finalReport.description,
            style: AppTextStyle.s14(color: color.onSurfaceVariant),
          ),
          _buildEvidences(color),
          _buildFooter(color),
        ],
      ),
    );
  }

  Widget _buildEvidences(ColorScheme color) {
    const int crossAxisCount = 3;
    const double gap = 16;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (gap * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: finalReport.evidences.map((evidence) {
            return Hero(
              tag: evidence,
              child: SizedBox(
                width: itemWidth,
                height: itemWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GestureDetector(
                    onTap: () {
                      Navigate.push(
                        context,
                        ImageViewerPage.network(
                          tag: evidence,
                          title: "Bukti Lapangan",
                          withDownload: true,
                          urlImage: evidence,
                        ),
                      );
                    },
                    child: Image.network(
                      evidence,
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
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFooter(ColorScheme color) {
    return Row(
      spacing: 4,
      children: [
        Icon(
          Icons.format_quote_outlined,
          size: 16,
          color: color.onPrimaryContainer,
        ),
        Text(
          'Hanya Baca • ${DateFormat('dd MMMM yyyy', 'id_ID').format(finalReport.createdAt)}',
          style: AppTextStyle.s12(
            color: color.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
