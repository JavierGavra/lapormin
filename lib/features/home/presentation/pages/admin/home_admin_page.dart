import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/report/presentation/pages/internal_report_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/card/report_card.dart';
import 'package:lapormin/core/widgets/loading/report_card_shimmer.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/home/presentation/widgets/location_banner/app_location_banner.dart';
import 'package:lapormin/core/widgets/card/quick_info_card.dart';
import 'package:lapormin/features/home/presentation/widgets/admin_home_greeting/admin_home_greeting.dart';
import 'package:lapormin/features/home/presentation/bloc/home_admin/home_admin_bloc.dart';

import '../../../../../core/widgets/loading/shimmer_widget.dart'
    show ShimmerWidget;

class HomeAdminPage extends StatefulWidget {
  final VoidCallback? onSeeAllTapped;

  const HomeAdminPage({super.key, this.onSeeAllTapped});

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  Future<void> _onRefresh() async {
    context.read<HomeAdminBloc>().add(const FetchHomeAdminReports());

    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: BlocListener<HomeAdminBloc, HomeAdminState>(
          listener: (context, state) {
            if (state.status == HomeAdminStatus.failure) {
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
                        const AdminHomeGreeting(),
                        const SizedBox(height: 24),

                        BlocBuilder<HomeAdminBloc, HomeAdminState>(
                          builder: (context, state) {
                            final displayLocation =
                                state.location ?? "Mencari lokasi...";
                            return LocationBanner(location: displayLocation);
                          },
                        ),

                        const SizedBox(height: 24),

                        BlocBuilder<HomeAdminBloc, HomeAdminState>(
                          builder: (context, state) {
                            final stats = state.statistics;
                            final isLoading =
                                state.status == HomeAdminStatus.loading ||
                                state.status == HomeAdminStatus.initial;

                            final pendingCount = isLoading
                                ? "..."
                                : (stats?.pending.toString() ?? "0");
                            final processingCount = isLoading
                                ? "..."
                                : (stats?.processing.toString() ?? "0");
                            final doneCount = isLoading
                                ? "..."
                                : (stats?.done.toString() ?? "0");
                            final totalCount = isLoading
                                ? "..."
                                : (stats?.total.toString() ?? "0");

                            Widget quickInfoContent = Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AdminQuickInfoCard(
                                        iconData: Icons.pending_actions,
                                        title: "Menunggu",
                                        count: pendingCount,
                                        backgroundColor: color.surface,
                                        iconBackgroundColor:
                                            color.primaryContainer,
                                        iconColor: color.onPrimaryContainer,
                                        textColor: color.primary,
                                        titleColor: color.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: AdminQuickInfoCard(
                                        iconData: Icons.cached,
                                        title: "Diproses",
                                        count: processingCount,
                                        backgroundColor: color.surface,
                                        iconBackgroundColor:
                                            color.tertiaryContainer,
                                        iconColor: color.onTertiaryContainer,
                                        textColor: color.tertiary,
                                        titleColor: color.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AdminQuickInfoCard(
                                        iconData: Icons.task_alt,
                                        title: "Selesai",
                                        count: doneCount,
                                        backgroundColor: color.surface,
                                        iconBackgroundColor:
                                            color.successContainer,
                                        iconColor: color.onSuccessContainer,
                                        textColor: color.success,
                                        titleColor: color.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: AdminQuickInfoCard(
                                        iconData: Icons.description_outlined,
                                        title: "Total Laporan",
                                        count: totalCount,
                                        backgroundColor: color.primary,
                                        iconBackgroundColor:
                                            color.surfaceContainerLowest,
                                        iconColor: color.primary,
                                        textColor: color.onPrimary,
                                        titleColor: color.surfaceContainerHigh,
                                        isLargeText: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );

                            if (isLoading) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ShimmerWidget(
                                          height: 128,
                                          width: double.infinity,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ShimmerWidget(
                                          height: 128,
                                          width: double.infinity,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ShimmerWidget(
                                          height: 128,
                                          width: double.infinity,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ShimmerWidget(
                                          height: 128,
                                          width: double.infinity,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ],
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
                              "Laporan Terbaru",
                              style: AppTextStyle.s16(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onSeeAllTapped,
                              behavior: HitTestBehavior.opaque,
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

                BlocBuilder<HomeAdminBloc, HomeAdminState>(
                  builder: (context, state) {
                    if (state.status != HomeAdminStatus.success) {
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
                            child: Text("Belum ada laporan yang masuk."),
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
                            imageUrl: report.evidence,
                            title: report.title,
                            location: report.shortAdddress,
                            timeAgo: timeAgoText,
                            status: report.status,
                            category: category,
                            deadlineDate: report.dueAction,
                            isVideo: report.evidence.endsWith('.mp4'),
                            onTap: () {
                              Navigate.push(
                                context,
                                InternalReportDetailPage(
                                  role: UserRole.admin,
                                  id: report.id,
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
