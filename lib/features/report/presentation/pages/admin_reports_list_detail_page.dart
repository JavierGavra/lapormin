import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/constants/report_category_enum.dart';
import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/constants/user_role_enum.dart';
import '../../../../core/route/navigate.dart';
import '../../../../core/utils/debouncer/debouncer.dart';
import '../../../../core/widgets/card/report_card.dart';
import '../../../../core/widgets/loading/compact_report_card_shimmer.dart';
import '../../../../core/widgets/loading/report_card_shimmer.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../domain/entities/report_summary.dart';
import '../../domain/params/report_filter_params.dart';
import '../bloc/admin_reports/admin_reports_bloc.dart';
import '../widgets/admin_report/admin_sliver_app_bar.dart';
import '../widgets/report_list/compact_report_card.dart';
import '../widgets/report_list/report_filter_bottom_sheet.dart';
import '../widgets/report_list/report_layout_switch.dart';
import '../widgets/report_list/report_search_bar.dart';
import 'internal_report_detail_page.dart';

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

            BlocConsumer<AdminReportsBloc, AdminReportsState>(
              listener: (context, state) {
                if (state.isFailure) {
                  showSnackBar(
                    context,
                    state.errorMessage ?? "Terjadi kesalahan",
                    type: SnackBarType.failure,
                  );
                }
              },
              builder: (context, state) {
                if (!state.isSuccess) {
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
        final category = ReportCategory.fromString(report.category);

        timeago.setLocaleMessages('id', timeago.IdMessages());
        final timeAgoText = timeago.format(report.createdAt, locale: 'id');

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
