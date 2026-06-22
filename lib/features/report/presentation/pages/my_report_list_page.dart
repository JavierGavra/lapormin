import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/user_role_enum.dart';
import '../../../../core/widgets/app_bar/custom_app_bar.dart';
import '../../../../core/widgets/loading/compact_report_card_shimmer.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../domain/entities/report_summary.dart';
import '../bloc/my_reports/my_reports_bloc.dart';
import '../widgets/report_list/compact_report_card.dart';
import 'internal_report_detail_page.dart';

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
          CustomAppBar(title: "Laporanku"),

          Expanded(
            child: RefreshIndicator(
              color: color.primary,
              backgroundColor: color.surfaceContainerHighest,
              onRefresh: _onRefresh,
              child: BlocConsumer<MyReportsBloc, MyReportsState>(
                listener: (context, state) {
                  if (state.status == MyReportsStatus.failure) {
                    showSnackBar(
                      context,
                      state.errorMessage ?? "Terjadi kesalahan",
                      type: SnackBarType.failure,
                    );
                  }
                },
                builder: (context, state) {
                  if (state.status != MyReportsStatus.success) {
                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16,
                      ),
                      itemCount: 4,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          const CompactReportCardShimmer(),
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
