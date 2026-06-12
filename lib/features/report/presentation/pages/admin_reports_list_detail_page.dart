import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/utils/debouncer/debouncer.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/presentation/pages/internal_report_detail_page.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_filter_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/widgets/report_card/report_card_shimmer.dart';
import 'package:lapormin/core/widgets/report_card/compact_report_card_shimmer.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/report/presentation/widgets/admin_report/admin_sliver_app_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';
import 'package:lapormin/features/report/presentation/bloc/admin_reports/admin_reports_bloc.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';

class AdminReportListDetailPage extends StatefulWidget {
  final String title;
  final ReportStatus? filterStatus;
  final ReportCategory? filterCategory;

  const AdminReportListDetailPage({
    super.key,
    required this.title,
    this.filterStatus,
    this.filterCategory,
  });

  @override
  State<AdminReportListDetailPage> createState() =>
      _AdminReportListDetailPageState();
}

class _AdminReportListDetailPageState extends State<AdminReportListDetailPage> {
  bool _isStyle1 = true;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void _fetchReports() {
    final presetFilter = ReportFilterParams(
      categories: widget.filterCategory != null ? [widget.filterCategory!] : [],
      statuses: widget.filterStatus != null ? [widget.filterStatus!] : [],
    );

    context.read<AdminReportsBloc>().add(
      FetchAdminReports(presetFilter: presetFilter),
    );
  }

  Future<void> _onRefresh() async {
    _fetchReports();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void _showFilterModal(BuildContext context, AdminReportsState state) async {
    final bool shouldHideCategory = widget.filterCategory != null;
    final bool shouldHideStatus = widget.filterStatus != null;

    final ReportFilterParams? result =
        await showModalBottomSheet<ReportFilterParams>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ReportFilterBottomSheet(
            currentFilter: state.filter,
            allowedStatuses: ReportStatus.values,
            hideCategory: shouldHideCategory,
            hideStatus: shouldHideStatus,
          ),
        );

    if (!context.mounted) return;
    if (result != null) {
      context.read<AdminReportsBloc>().add(UpdateAdminFilter(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: RefreshIndicator(
        color: color.primary,
        backgroundColor: color.surfaceContainerHighest,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            AdminSliverAppBar(
              title: widget.title,
              onBackTap: () => Navigator.pop(context),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<AdminReportsBloc, AdminReportsState>(
                        builder: (context, state) {
                          return ReportSearchBar(
                            onChanged: (text) {
                              _debouncer.run(() {
                                final updatedFilter = ReportFilterParams(
                                  keyword: text,
                                  categories: state.filter.categories,
                                  statuses: state.filter.statuses,
                                );
                                context.read<AdminReportsBloc>().add(
                                  UpdateAdminFilter(updatedFilter),
                                );
                              });
                            },
                            onFilterTap: () => _showFilterModal(context, state),
                            onSearchTap: () {},
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ReportLayoutSwitch(
                      isStyle1: _isStyle1,
                      onSwitch: (val) => setState(() => _isStyle1 = val),
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<AdminReportsBloc, AdminReportsState>(
              builder: (context, state) {
                if (state.status == AdminReportsStatus.loading ||
                    state.status == AdminReportsStatus.initial) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    sliver: SliverList.separated(
                      itemCount: 4,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _isStyle1
                            ? const ReportCardShimmer()
                            : const CompactReportCardShimmer();
                      },
                    ),
                  );
                }

                if (state.status == AdminReportsStatus.failure) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          state.errorMessage ?? "Gagal memuat laporan admin.",
                          style: TextStyle(color: color.error),
                        ),
                      ),
                    ),
                  );
                }

                if (state.reports.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          "Tidak ada laporan pada kategori/status ini.",
                          style: TextStyle(color: color.onSurfaceVariant),
                        ),
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
      key: const ValueKey("AdminStyle1Sliver"),
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
            Navigate.push(
              context,
              InternalReportDetailPage(role: UserRole.admin, id: report.id),
            );
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
      key: const ValueKey("AdminStyle2Sliver"),
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
            Navigate.push(
              context,
              InternalReportDetailPage(role: UserRole.admin, id: report.id),
            );
          },
        );
      },
    );
  }
}
