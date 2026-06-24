import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/constants/report_category_enum.dart';
import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/route/navigate.dart';
import '../../../../core/utils/debouncer/debouncer.dart';
import '../../../../core/widgets/card/report_card.dart';
import '../../../../core/widgets/loading/compact_report_card_shimmer.dart';
import '../../../../core/widgets/loading/report_card_shimmer.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../domain/entities/report_summary.dart';
import '../../domain/params/report_filter_params.dart';
import '../bloc/public_reports/public_reports_bloc.dart';
import '../widgets/admin_report/admin_sliver_app_bar.dart';
import '../widgets/report_list/compact_report_card.dart';
import '../widgets/report_list/report_filter_bottom_sheet.dart';
import '../widgets/report_list/report_layout_switch.dart';
import '../widgets/report_list/report_search_bar.dart';
import 'public_report_detail_page.dart';

class PublicCategoryReportListPage extends StatefulWidget {
  final String title;
  final ReportCategory filterCategory;

  const PublicCategoryReportListPage({
    super.key,
    required this.title,
    required this.filterCategory,
  });

  @override
  State<PublicCategoryReportListPage> createState() =>
      _PublicCategoryReportListPageState();
}

class _PublicCategoryReportListPageState
    extends State<PublicCategoryReportListPage> {
  bool _isStyle1 = true;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  final List<ReportStatus> _allowedStatuses = const [
    ReportStatus.verified,
    ReportStatus.fieldCheck,
    ReportStatus.action,
    ReportStatus.done,
  ];

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
      categories: [widget.filterCategory],
      statuses: _allowedStatuses,
    );

    context.read<PublicReportsBloc>().add(UpdatePublicFilter(presetFilter));
  }

  Future<void> _onRefresh() async {
    _fetchReports();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void _showFilterModal(BuildContext context, PublicReportsState state) async {
    final ReportFilterParams? result =
        await showModalBottomSheet<ReportFilterParams>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ReportFilterBottomSheet(
            currentFilter: state.filter,
            allowedStatuses: _allowedStatuses,
            hideCategory: true,
            hideStatus: false,
          ),
        );

    if (!context.mounted) return;
    if (result != null) {
      context.read<PublicReportsBloc>().add(UpdatePublicFilter(result));
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
                      child: BlocBuilder<PublicReportsBloc, PublicReportsState>(
                        builder: (context, state) {
                          return ReportSearchBar(
                            onChanged: (text) {
                              _debouncer.run(() {
                                final updatedFilter = ReportFilterParams(
                                  keyword: text,
                                  categories: state.filter.categories,
                                  statuses: state.filter.statuses,
                                );
                                context.read<PublicReportsBloc>().add(
                                  UpdatePublicFilter(updatedFilter),
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

            BlocConsumer<PublicReportsBloc, PublicReportsState>(
              listener: (context, state) {
                if (state.status == PublicReportsStatus.failure) {
                  showSnackBar(
                    context,
                    state.errorMessage ?? "Terjadi kesalahan",
                    type: SnackBarType.failure,
                  );
                }
              },
              builder: (context, state) {
                if (state.status == PublicReportsStatus.loading ||
                    state.status == PublicReportsStatus.initial) {
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
                          "Belum ada laporan tervalidasi di kategori ini.",
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
      key: const ValueKey("PublicStyle1Sliver"),
      itemCount: reports.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final report = reports[index];
        final category = ReportCategory.fromString(report.category);

        timeago.setLocaleMessages('id', timeago.IdMessages());
        final timeAgoText = timeago.format(report.createdAt, locale: 'id');

        return ReportCard(
          imageUrl: report.evidence.previewUrl,
          title: report.title,
          location: report.shortAdddress,
          timeAgo: timeAgoText,
          status: report.status,
          category: category,
          deadlineDate: report.dueAction,
          isVideo: report.evidence.isVideo,
          onTap: () {
            Navigate.push(context, PublicReportDetailPage(id: report.id));
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
      key: const ValueKey("PublicStyle2Sliver"),
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
            Navigate.push(context, PublicReportDetailPage(id: report.id));
          },
        );
      },
    );
  }
}
