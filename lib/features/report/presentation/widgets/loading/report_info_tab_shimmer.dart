import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';

class ReportInfoTabShimmer extends StatelessWidget {
  const ReportInfoTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              _buildInfoTags(),
              _buildInfoHeader(),
              _buildLocationBanner(),
              _buildInfoDescription(),
              _buildInfoEvidences(context),
              _buildInfoMap(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTags() {
    return SizedBox(
      height: 20,
      child: Row(
        spacing: 6,
        children: [
          ShimmerWidget(width: 119, borderRadius: BorderRadius.circular(12)),
          ShimmerWidget(width: 98, borderRadius: BorderRadius.circular(12)),
        ],
      ),
    );
  }

  Widget _buildInfoHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        SizedBox(
          height: 32,
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: ShimmerWidget(borderRadius: BorderRadius.circular(4)),
              ),
              ShimmerWidget(width: 32, borderRadius: BorderRadius.circular(4)),
            ],
          ),
        ),
        ShimmerWidget(
          height: 20,
          width: 155,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildLocationBanner() {
    return ShimmerWidget(height: 56, borderRadius: BorderRadius.circular(12));
  }

  Widget _buildInfoDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        ShimmerWidget(
          height: 24,
          width: 103,
          borderRadius: BorderRadius.circular(4),
        ),
        Column(
          spacing: 4,
          children: List.generate(
            2,
            (index) => ShimmerWidget(
              height: 18,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoMap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        ShimmerWidget(
          height: 24,
          width: 108,
          borderRadius: BorderRadius.circular(4),
        ),
        ShimmerWidget(height: 190, borderRadius: BorderRadius.circular(16)),
      ],
    );
  }

  Widget _buildInfoEvidences(BuildContext context) {
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
          ShimmerWidget(
            height: 16,
            width: 100,
            borderRadius: BorderRadius.circular(4),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth =
                  (constraints.maxWidth - (gap * (crossAxisCount - 1))) /
                  crossAxisCount;

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: List.generate(
                  6,
                  (index) => ShimmerWidget(
                    width: itemWidth,
                    height: itemWidth,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
