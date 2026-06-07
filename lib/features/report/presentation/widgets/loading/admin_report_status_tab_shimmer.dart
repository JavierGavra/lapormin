import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';

class AdminReportStatusTabShimmer extends StatelessWidget {
  const AdminReportStatusTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              ShimmerWidget(
                height: 152,
                borderRadius: BorderRadius.circular(12),
              ),
              ShimmerWidget(
                height: 104,
                borderRadius: BorderRadius.circular(12),
              ),
              // if (fieldCheck != null) FieldCheckCard(fieldCheck: fieldCheck),

              // if (report.status == ReportStatus.verified)
              //   DueActionField(
              //     onChanged: (date) {
              //       _input.value = date;
              //     },
              //   ),

              // if (finalReport != null) FinalReportCard(finalReport: finalReport),

              // if (report.status == ReportStatus.rejected)
              //   _buildRejectedInfoCard(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ShimmerWidget(
            height: 56,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
