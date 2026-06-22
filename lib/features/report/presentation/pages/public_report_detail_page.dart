import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/loading/public_report_detail_shimmer.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/widgets/button/app_back_button.dart';
import '../../../../core/widgets/button/app_icon_button.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../../../injection.dart';
import '../../../home/presentation/widgets/location_banner/app_location_banner.dart';
import '../bloc/public_report_detail/public_report_detail_bloc.dart';
import '../widgets/report_detail/information/carousel_report_info_evidences.dart';
import '../widgets/report_detail/information/report_info_description.dart';
import '../widgets/report_detail/information/report_info_header.dart';
import '../widgets/report_detail/information/report_info_map.dart';
import '../widgets/report_detail/information/report_info_tags.dart';

class PublicReportDetailPage extends StatelessWidget {
  final String id;

  const PublicReportDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) =>
          sl<PublicReportDetailBloc>()..add(PublicReportDetailOpened(id)),
      child: Scaffold(
        backgroundColor: color.secondaryContainer,
        body: BlocListener<PublicReportDetailBloc, PublicReportDetailState>(
          listener: (context, state) {
            if (state.status == PublicReportDetailStatus.failure) {
              showSnackBar(
                context,
                state.errorMessage ?? "Gagal memuat laporan",
                type: SnackBarType.failure,
              );
            }
          },
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                  "assets/images/backgrounds/report_detail_background.png",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<PublicReportDetailBloc>().add(
                      PublicReportDetailOpened(id),
                    );
                  },
                  child: _buildContent(color),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildContent(ColorScheme color) {
    return BlocBuilder<PublicReportDetailBloc, PublicReportDetailState>(
      builder: (context, state) {
        if (!state.isSuccess) return PublicReportDetailShimmer();

        final report = state.report!;

        return CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 20),
              sliver: SliverToBoxAdapter(
                child: CarouselReportInfoEvidences(evidences: report.evidences),
              ),
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
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
                      ReportInfoTags(
                        ticket: report.ticket,
                        status: report.status,
                      ),
                      ReportInfoHeader(
                        title: report.title,
                        createdAt: report.createdAt,
                        category: report.category,
                      ),
                      LocationBanner(location: report.address, isSmall: true),
                      ReportInfoDescription(description: report.description),
                      ReportInfoMap(
                        position: LatLng(report.latitude, report.longitude),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
