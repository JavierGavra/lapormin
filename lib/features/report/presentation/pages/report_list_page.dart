import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/report/presentation/pages/my_report_list_page.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/my_report_fab.dart';
import 'package:lapormin/features/report/presentation/bloc/public_reports/public_reports_bloc.dart';
import 'package:lapormin/core/widgets/report_card/report_card_shimmer.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  bool _isStyle1 = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      floatingActionButton: MyReportFab(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyReportListPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppSliverAppBar(
              profileUrl: "assets/images/profiles/profile.png",
              onNotificationTap: () {
                debugPrint("Buka Notifikasi Laporan");
              },
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ReportSearchBar(
                        onSearchTap: () {
                          debugPrint("Buka halaman cari");
                        },
                        onFilterTap: () {
                          debugPrint("Buka Modal Filter pencarian");
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ReportLayoutSwitch(
                      isStyle1: _isStyle1,
                      onSwitch: (value) {
                        setState(() {
                          _isStyle1 = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<PublicReportsBloc, PublicReportsState>(
              builder: (context, state) {
                if (state.status == PublicReportsStatus.loading ||
                    state.status == PublicReportsStatus.initial) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverList.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: ReportCardShimmer(),
                      ),
                    ),
                  );
                }

                if (state.status == PublicReportsStatus.failure) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          state.errorMessage ?? "Gagal memuat laporan",
                          style: TextStyle(color: color.error),
                        ),
                      ),
                    ),
                  );
                }

                if (state.reports.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text("Belum ada laporan sama sekali."),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: _isStyle1
                      ? _buildStyle1SliverList(color, state.reports)
                      : _buildStyle2SliverList(color, state.reports),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildStyle1SliverList(
    ColorScheme color,
    List<ReportSummary> reports,
  ) {
    return SliverList.separated(
      key: const ValueKey("Style1Sliver"),
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final report = reports[index];
        final categoryEnum = ReportCategory.fromString(report.category);
        timeago.setLocaleMessages('id', timeago.IdMessages());
        final timeAgoText = timeago.format(report.createdAt, locale: 'id');

        return ReportCard(
          imageUrl: report.evidence,
          title: report.title,
          location: report.shortAdddress,
          timeAgo: timeAgoText,
          status: report.status,
          categoryIcon: categoryEnum.icon,
          categoryColor: categoryEnum.getColor(context).containerColor,
          deadlineDate: report.dueAction,
          isVideo: report.evidence.endsWith('.mp4'),
          onTap: () {
            debugPrint("Buka Detail Style 1: ${report.id}");
          },
        );
      },
    );
  }

  Widget _buildStyle2SliverList(
    ColorScheme color,
    List<ReportSummary> reports,
  ) {
    return SliverList.separated(
      key: const ValueKey("Style2Sliver"),
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = reports[index];
        timeago.setLocaleMessages('id', timeago.IdMessages());
        final timeAgoText = timeago.format(report.createdAt, locale: 'id');

        return CompactReportCard(
          title: report.title,
          location: report.shortAdddress,
          timeAgo: timeAgoText,
          status: report.status,
          deadlineDate: report.dueAction,
          onTap: () {
            debugPrint("Buka Detail Style 2: ${report.id}");
          },
        );
      },
    );
  }
}
