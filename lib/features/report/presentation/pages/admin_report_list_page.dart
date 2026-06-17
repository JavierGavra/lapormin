import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/features/home/presentation/bloc/home_admin/home_admin_bloc.dart';
import 'package:lapormin/features/report/presentation/pages/admin_reports_list_detail_page.dart';
import 'package:lapormin/features/report/presentation/widgets/admin_report/admin_info_banner.dart';
import 'package:lapormin/features/report/presentation/widgets/admin_report/admin_stat_card.dart';
import 'package:lapormin/features/report/presentation/widgets/admin_report/admin_category_stat_card.dart';

class AdminReportListPage extends StatefulWidget {
  const AdminReportListPage({super.key});

  @override
  State<AdminReportListPage> createState() => _AdminReportListPageState();
}

class _AdminReportListPageState extends State<AdminReportListPage> {
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
        child: RefreshIndicator(
          color: color.primary,
          backgroundColor: color.surfaceContainerHighest,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              AppSliverAppBar(
                profileUrl: "assets/images/profiles/profile.png",
                onNotificationTap: () {
                  debugPrint("Buka Notifikasi Admin");
                },
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: BlocBuilder<HomeAdminBloc, HomeAdminState>(
                    builder: (context, state) {
                      final stats = state.statistics;
                      final isLoading =
                          state.status == HomeAdminStatus.loading ||
                          state.status == HomeAdminStatus.initial;

                      final totalCount = isLoading
                          ? "..."
                          : (stats?.total.toString() ?? "0");
                      final pendingCount = isLoading
                          ? "..."
                          : (stats?.pending.toString() ?? "0");

                      final infraCount = isLoading
                          ? "..."
                          : "${stats?.infrastructure ?? 0} laporan";
                      final disasterCount = isLoading
                          ? "..."
                          : "${stats?.disaster ?? 0} laporan";
                      final crimeCount = isLoading
                          ? "..."
                          : "${stats?.crime ?? 0} laporan";
                      final publicServiceCount = isLoading
                          ? "..."
                          : "${stats?.publicService ?? 0} laporan";

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdminInfoBanner(
                            onTap: () => debugPrint("Banner Admin Info Diklik"),
                          ),
                          const SizedBox(height: 24),

                          AdminStatCard(
                            title: "Semua Laporan",
                            subtitle: "Laporan dari masyarakat",
                            count: totalCount,
                            icon: Icons.assignment_outlined,
                            iconBackgroundColor: color.surfaceContainer,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminReportListDetailPage(
                                        title: "Semua Laporan",
                                      ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          AdminStatCard(
                            title: "Menunggu Verifikasi",
                            subtitle:
                                "Ada laporan yang menunggu untuk di verifikasi",
                            count: pendingCount,
                            icon: Icons.pending_actions_outlined,
                            iconBackgroundColor: color.surfaceContainer,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminReportListDetailPage(
                                        title: "Menunggu Verifikasi",
                                        filterStatus: ReportStatus.pending,
                                      ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'Kategori',
                            style: AppTextStyle.s16(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: AdminCategoryStatCard(
                                  title: "Infrastruktur",
                                  count: infraCount,
                                  icon: Icons.apartment_outlined,
                                  backgroundColor: color.primaryContainer,
                                  titleColor: color.onPrimaryContainer,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminReportListDetailPage(
                                              title: "Infrastruktur",
                                              filterCategory:
                                                  ReportCategory.infrastructure,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AdminCategoryStatCard(
                                  title: "Bencana",
                                  count: disasterCount,
                                  icon: Icons.flood_outlined,
                                  backgroundColor: color.warningContainer,
                                  titleColor: color.onWarningContainer,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminReportListDetailPage(
                                              title: "Bencana",
                                              filterCategory:
                                                  ReportCategory.disaster,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: AdminCategoryStatCard(
                                  title: "Kriminal",
                                  count: crimeCount,
                                  icon: Icons.warning_amber_rounded,
                                  backgroundColor: color.errorContainer,
                                  titleColor: color.onErrorContainer,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminReportListDetailPage(
                                              title: "Kriminal",
                                              filterCategory:
                                                  ReportCategory.crime,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AdminCategoryStatCard(
                                  title: "Layanan Publik",
                                  count: publicServiceCount,
                                  icon: Icons.account_balance_outlined,
                                  backgroundColor: color.successContainer,
                                  titleColor: color.onSuccessContainer,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AdminReportListDetailPage(
                                              title: "Layanan Publik",
                                              filterCategory:
                                                  ReportCategory.publicService,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
