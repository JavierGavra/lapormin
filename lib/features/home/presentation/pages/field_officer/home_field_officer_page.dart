import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/report/presentation/pages/internal_report_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/card/report_card.dart';
import 'package:lapormin/core/widgets/loading/report_card_shimmer.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/home/presentation/widgets/location_banner/app_location_banner.dart';
import 'package:lapormin/core/widgets/card/quick_info_card.dart';
import 'package:lapormin/features/home/presentation/widgets/field_officer_home_greeting/field_officer_home_greeting.dart';
import 'package:lapormin/features/report/presentation/bloc/field_officer_reports/field_officer_reports_bloc.dart';

class HomeFieldOfficerPage extends StatefulWidget {
  final VoidCallback onNavigateToReports;

  const HomeFieldOfficerPage({super.key, required this.onNavigateToReports});

  @override
  State<HomeFieldOfficerPage> createState() => _HomeFieldOfficerPageState();
}

class _HomeFieldOfficerPageState extends State<HomeFieldOfficerPage> {
  Future<void> _onRefresh() async {
    context.read<FieldOfficerReportsBloc>().add(
      const FetchFieldOfficerReports(),
    );
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: BlocListener<FieldOfficerReportsBloc, FieldOfficerReportsState>(
          listener: (context, state) {
            if (state.status == FieldOfficerReportsStatus.failure) {
              showSnackBar(
                context,
                state.errorMessage ?? "Terjadi kesalahan",
                type: SnackBarType.failure,
              );
            }
          },
          child: RefreshIndicator(
            color: color.primary,
            backgroundColor: color.surfaceContainerHighest,
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                AppSliverAppBar(),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldOfficerHomeGreeting(),
                        const SizedBox(height: 24),

                        BlocBuilder<
                          FieldOfficerReportsBloc,
                          FieldOfficerReportsState
                        >(
                          builder: (context, state) {
                            final displayLocation =
                                state.location ?? "Mencari lokasi...";
                            return LocationBanner(location: displayLocation);
                          },
                        ),

                        const SizedBox(height: 24),

                        BlocBuilder<
                          FieldOfficerReportsBloc,
                          FieldOfficerReportsState
                        >(
                          builder: (context, state) {
                            final stats = state.statistics;
                            final isLoading =
                                state.status ==
                                    FieldOfficerReportsStatus.loading ||
                                state.status ==
                                    FieldOfficerReportsStatus.initial;

                            final inspeksiCount = isLoading
                                ? "..."
                                : (stats?.inspeksi.toString() ?? "0");
                            final tindakanCount = isLoading
                                ? "..."
                                : (stats?.tindakan.toString() ?? "0");
                            final penugasanCount = isLoading
                                ? "..."
                                : (stats?.penugasan.toString() ?? "0");

                            Widget quickInfoContent = Row(
                              children: [
                                Expanded(
                                  child: AdminQuickInfoCard(
                                    iconData:
                                        Icons.content_paste_search_outlined,
                                    title: "Inspeksi",
                                    count: inspeksiCount,
                                    backgroundColor: Colors.white,
                                    iconBackgroundColor: color.warningContainer,
                                    iconColor: color.onWarningContainer,
                                    textColor: color.warning,
                                    titleColor: color.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AdminQuickInfoCard(
                                    iconData: Icons.build_outlined,
                                    title: "Tindakan",
                                    count: tindakanCount,
                                    backgroundColor: Colors.white,
                                    iconBackgroundColor:
                                        color.tertiaryContainer,
                                    iconColor: color.onTertiaryContainer,
                                    textColor: color.tertiary,
                                    titleColor: color.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AdminQuickInfoCard(
                                    iconData: Icons.assignment_outlined,
                                    title: "Penugasan",
                                    count: penugasanCount,
                                    backgroundColor: color.primary,
                                    iconBackgroundColor: Colors.white,
                                    iconColor: color.primary,
                                    textColor: color.onPrimary,
                                    titleColor: color.surfaceContainerHigh,
                                    isLargeText: true,
                                  ),
                                ),
                              ],
                            );

                            if (isLoading) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ShimmerWidget(
                                      height: 128,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ShimmerWidget(
                                      height: 128,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ShimmerWidget(
                                      height: 128,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return quickInfoContent;
                          },
                        ),

                        const SizedBox(height: 24),
                        Container(
                          height: 2,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: color.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Penugasan Terbaru",
                              style: AppTextStyle.s16(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onNavigateToReports,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Lihat Semua",
                                    style: AppTextStyle.s14(
                                      color: color.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: color.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<FieldOfficerReportsBloc, FieldOfficerReportsState>(
                  builder: (context, state) {
                    if (state.status != FieldOfficerReportsStatus.success) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        sliver: SliverList.separated(
                          itemCount: 3,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) =>
                              const ReportCardShimmer(),
                        ),
                      );
                    }

                    if (state.reports.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text("Yey! Belum ada penugasan baru."),
                          ),
                        ),
                      );
                    }

                    final displayReports = state.reports.take(5).toList();

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverList.separated(
                        itemCount: displayReports.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final report = displayReports[index];
                          final category = ReportCategory.fromString(
                            report.category,
                          );

                          timeago.setLocaleMessages('id', timeago.IdMessages());
                          final timeAgoText = timeago.format(
                            report.createdAt,
                            locale: 'id',
                          );

                          return ReportCard(
                            imageUrl: report.evidence.previewUrl,
                            title: report.title,
                            location: report.shortAdddress,
                            timeAgo: timeAgoText,
                            status: report.status,
                            category: category,
                            isVideo: report.evidence.isVideo,
                            deadlineDate: report.dueAction,

                            onTap: () {
                              Navigate.push(
                                context,
                                InternalReportDetailPage(
                                  id: report.id,
                                  role: UserRole.fieldOfficer,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
