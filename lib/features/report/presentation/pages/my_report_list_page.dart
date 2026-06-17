import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/core/widgets/loading/compact_report_card_shimmer.dart';
import 'package:lapormin/features/report/presentation/pages/internal_report_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/bloc/my_reports/my_reports_bloc.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';

class MyReportListPage extends StatefulWidget {
  const MyReportListPage({super.key});

  @override
  State<MyReportListPage> createState() => _MyReportListPageState();
}

class _MyReportListPageState extends State<MyReportListPage> {
  @override
  void initState() {
    super.initState();
    _fetchMyReports();
  }

  void _fetchMyReports() {
    context.read<MyReportsBloc>().add(const FetchMyReports());
  }

  Future<void> _onRefresh() async {
    _fetchMyReports();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Column(
        children: [
          _buildCustomHeader(context, color),

          Expanded(
            child: RefreshIndicator(
              color: color.primary,
              backgroundColor: color.surfaceContainerHighest,
              onRefresh: _onRefresh,
              child: BlocBuilder<MyReportsBloc, MyReportsState>(
                builder: (context, state) {
                  if (state.status == MyReportsStatus.loading ||
                      state.status == MyReportsStatus.initial) {
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 24.0,
                      ),
                      itemCount: 4,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          const CompactReportCardShimmer(),
                    );
                  }

                  if (state.status == MyReportsStatus.failure) {
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              state.errorMessage ?? "Gagal memuat laporanku",
                              style: TextStyle(color: color.error),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  if (state.reports.isEmpty) {
                    return const CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Text("Kamu belum membuat laporan apapun."),
                          ),
                        ),
                      ],
                    );
                  }

                  return _buildMyReportList(color, state.reports);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, ColorScheme color) {
    final topPadding = MediaQuery.of(context).padding.top;
    final color = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding + 16.0,
        bottom: 16.0,
        left: 24.0,
        right: 24.0,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: color.onSurface.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back, color: color.onSurface, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Laporanku',
            style: AppTextStyle.s16(
              color: color.primary,
              fontWeight: FontWeight.w600,
              fontFamily: 'DM Sans',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyReportList(ColorScheme color, List<ReportSummary> reports) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InternalReportDetailPage(
                  id: report.id,
                  role: UserRole.informant,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
