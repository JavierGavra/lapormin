import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../injection.dart';
import '../../../../core/widgets/button/app_back_button.dart';
import '../../../../core/widgets/button/app_icon_button.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../../home/presentation/widgets/location_banner/app_location_banner.dart';
import '../bloc/public_report_detail/public_report_detail_bloc.dart';
import '../widgets/report_detail/information/report_info_description.dart';
import '../widgets/report_detail/information/report_info_header.dart';
import '../widgets/report_detail/information/report_info_map.dart';
import '../widgets/report_detail/information/report_info_tags.dart';

class PublicReportDetailPage extends StatefulWidget {
  final String id;

  const PublicReportDetailPage({super.key, required this.id});

  @override
  State<PublicReportDetailPage> createState() => _PublicReportDetailPageState();
}

class _PublicReportDetailPageState extends State<PublicReportDetailPage> {
  final _controller = CarouselController();

  Timer? _carouselTimer;

  final List<String> _evidences = [
    "assets/images/cards/banjir.png",
    "assets/images/cards/infrastruktur.png",
    "assets/images/cards/kriminal.png",
  ];

  void _startAutoSlide() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        final double currentOffset = _controller.offset;
        final double maxScrollExtent = _controller.position.maxScrollExtent;
        double nextOffset = currentOffset + 200;

        if (currentOffset >= maxScrollExtent) {
          nextOffset = 0;
        }

        _controller.animateTo(
          nextOffset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) =>
          sl<PublicReportDetailBloc>()
            ..add(PublicReportDetailOpened(widget.id)),
      child: Scaffold(
        backgroundColor: color.secondaryContainer,
        body: BlocConsumer<PublicReportDetailBloc, PublicReportDetailState>(
          listener: (context, state) {
            if (state.status == PublicReportDetailStatus.failure) {
              showSnackBar(
                context,
                state.errorMessage ?? "Gagal memuat laporan",
                type: SnackBarType.failure,
              );
            }
          },
          builder: (context, state) {
            if (!state.isSuccess) {
              return const Center(child: CircularProgressIndicator());
            }

            final report = state.report!;

            return SizedBox(
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
                        PublicReportDetailOpened(widget.id),
                      );
                    },
                    child: CustomScrollView(
                      slivers: [
                        _buildAppBar(context),
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(18, 16, 18, 20),
                          sliver: SliverToBoxAdapter(
                            child: SizedBox(
                              height: 135,
                              child: CarouselView.weightedBuilder(
                                controller: _controller,
                                itemSnapping: true,
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                flexWeights: [5, 1],
                                itemCount: _evidences.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      _evidences[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
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
                                  LocationBanner(
                                    location: report.address,
                                    isSmall: true,
                                  ),
                                  ReportInfoDescription(
                                    description: report.description,
                                  ),
                                  ReportInfoMap(
                                    position: LatLng(
                                      report.latitude,
                                      report.longitude,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
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
}
