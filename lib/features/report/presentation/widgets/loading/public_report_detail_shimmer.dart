import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/button/app_back_button.dart';
import 'package:lapormin/core/widgets/button/app_icon_button.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';

class PublicReportDetailShimmer extends StatelessWidget {
  const PublicReportDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(18, 16, 18, 20),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 135,
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    flex: 5,
                    child: ShimmerWidget(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ShimmerWidget(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              color: color.surface,
            ),
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
                  _buildInfoMap(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      titleSpacing: 16,
      leadingWidth: 24 + 40, // (Padding kiri) + (Lebar tombol)
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      actionsPadding: const EdgeInsets.only(right: 24),
      leading: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: AppBackButton(backgroundColor: color.surface),
          ),
        ),
      ),
      actions: [
        AppIconButton(
          icon: Icons.share,
          backgroundColor: color.surface,
          onPressed: () => showSnackBar(
            context,
            "Fitur belum tersedia",
            type: SnackBarType.failure,
          ),
        ),
      ],
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
    return ShimmerWidget(height: 190, borderRadius: BorderRadius.circular(16));
  }
}
