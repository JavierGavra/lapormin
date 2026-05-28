import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/widgets/report_card/report_card_shimmer.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';
import 'package:lapormin/features/report/presentation/bloc/field_officer_reports/field_officer_reports_bloc.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';

class FieldOfficerReportListPage extends StatefulWidget {
  const FieldOfficerReportListPage({super.key});

  @override
  State<FieldOfficerReportListPage> createState() =>
      _FieldOfficerReportListPageState();
}

class _FieldOfficerReportListPageState
    extends State<FieldOfficerReportListPage> {
  bool _isStyle1 = true;

  @override
  void initState() {
    super.initState();
    context.read<FieldOfficerReportsBloc>().add(
      const FetchFieldOfficerReports(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: CustomScrollView(
        slivers: [
          AppSliverAppBar(
            profileUrl: "assets/images/profiles/profile.png",
            onNotificationTap: () {
              debugPrint("Buka notifikasi petugas");
            },
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                top: 16.0,
                bottom: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ReportSearchBar(
                      onSearchTap: () => debugPrint("Cari penugasan"),
                      onFilterTap: () => debugPrint("Filter penugasan"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ReportLayoutSwitch(
                    isStyle1: _isStyle1,
                    onSwitch: (val) => setState(() => _isStyle1 = val),
                  ),
                ],
              ),
            ),
          ),

          BlocBuilder<FieldOfficerReportsBloc, FieldOfficerReportsState>(
            builder: (context, state) {
              if (state.status == FieldOfficerReportsStatus.loading ||
                  state.status == FieldOfficerReportsStatus.initial) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverList.separated(
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return const ReportCardShimmer();
                    },
                  ),
                );
              }

              if (state.status == FieldOfficerReportsStatus.failure) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        state.errorMessage ?? "Gagal memuat daftar penugasan.",
                        style: TextStyle(color: color.error),
                        textAlign: TextAlign.center,
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
                      child: Text("Yey! Tidak ada penugasan untukmu saat ini."),
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
    );
  }

  Widget _buildStyle1SliverList(
    ColorScheme color,
    List<ReportSummary> reports,
  ) {
    return SliverList.separated(
      key: const ValueKey("Style1"),
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
          deadlineDate: report.dueAction,
          categoryIcon: categoryEnum.icon,
          categoryColor: categoryEnum.getColor(context).containerColor,
          isVideo: report.evidence.endsWith('.mp4'),
          onTap: () => debugPrint("Detail Penugasan diklik: ${report.id}"),
        );
      },
    );
  }

  Widget _buildStyle2SliverList(
    ColorScheme color,
    List<ReportSummary> reports,
  ) {
    return SliverList.separated(
      key: const ValueKey("Style2"),
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
          onTap: () => debugPrint("Detail Penugasan diklik: ${report.id}"),
        );
      },
    );
  }
}
