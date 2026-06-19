import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/utils/debouncer/debouncer.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/presentation/pages/internal_report_detail_page.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_filter_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/card/report_card.dart';
import 'package:lapormin/core/widgets/loading/report_card_shimmer.dart';
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
    context.read<FieldOfficerReportsBloc>().add(
      const FetchFieldOfficerReports(),
    );
  }

  Future<void> _onRefresh() async {
    _fetchReports();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  void _showFilterModal(
    BuildContext context,
    FieldOfficerReportsState state,
  ) async {
    final allowedStatuses = ReportStatus.values
        .where((status) => status != ReportStatus.pending)
        .toList();

    final ReportFilterParams? result =
        await showModalBottomSheet<ReportFilterParams>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ReportFilterBottomSheet(
            currentFilter: state.filter,
            allowedStatuses: allowedStatuses,
          ),
        );

    if (!context.mounted) return;
    if (result != null) {
      context.read<FieldOfficerReportsBloc>().add(
        UpdateFieldOfficerFilter(result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: BlocListener<FieldOfficerReportsBloc, FieldOfficerReportsState>(
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
              AppSliverAppBar(
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
                        child:
                            BlocBuilder<
                              FieldOfficerReportsBloc,
                              FieldOfficerReportsState
                            >(
                              builder: (context, state) {
                                return ReportSearchBar(
                                  onChanged: (text) {
                                    _debouncer.run(() {
                                      final updatedFilter = ReportFilterParams(
                                        keyword: text,
                                        categories: state.filter.categories,
                                        statuses: state.filter.statuses,
                                      );
                                      context
                                          .read<FieldOfficerReportsBloc>()
                                          .add(
                                            UpdateFieldOfficerFilter(
                                              updatedFilter,
                                            ),
                                          );
                                    });
                                  },
                                  onFilterTap: () =>
                                      _showFilterModal(context, state),
                                  onSearchTap: () {},
                                );
                              },
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
                  if (state.status != FieldOfficerReportsStatus.success) {
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

                  if (state.reports.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            "Yey! Tidak ada penugasan untukmu saat ini.",
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
        final category = ReportCategory.fromString(report.category);

        timeago.setLocaleMessages('id', timeago.IdMessages());
        final timeAgoText = timeago.format(report.createdAt, locale: 'id');

        return ReportCard(
          imageUrl: report.evidence,
          title: report.title,
          location: report.shortAdddress,
          timeAgo: timeAgoText,
          status: report.status,
          deadlineDate: report.dueAction,
          category: category,
          isVideo: report.evidence.endsWith('.mp4'),
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
    );
  }
}
