import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/utils/debouncer/debouncer.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_filter_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/card/report_card.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/report/presentation/pages/my_report_list_page.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/my_report_fab.dart';
import 'package:lapormin/features/report/presentation/bloc/public_reports/public_reports_bloc.dart';
import 'package:lapormin/core/widgets/loading/report_card_shimmer.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/presentation/pages/public_report_detail_page.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  bool _isStyle1 = true;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future<void> _onRefresh() async {
    context.read<PublicReportsBloc>().add(const FetchPublicReports());
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  void _showFilterModal(BuildContext context, PublicReportsState state) async {
    final publicStatuses = [
      ReportStatus.fieldCheck,
      ReportStatus.verified,
      ReportStatus.action,
      ReportStatus.done,
    ];

    final ReportFilterParams? result =
        await showModalBottomSheet<ReportFilterParams>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ReportFilterBottomSheet(
            currentFilter: state.filter,
            allowedStatuses: publicStatuses,
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
        child: BlocListener<PublicReportsBloc, PublicReportsState>(
          listener: (context, state) {
            if (state.status == PublicReportsStatus.failure) {
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
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<
                                PublicReportsBloc,
                                PublicReportsState
                              >(
                                builder: (context, state) {
                                  return ReportSearchBar(
                                    onChanged: (text) {
                                      _debouncer.run(() {
                                        final updatedFilter =
                                            ReportFilterParams(
                                              keyword: text,
                                              categories:
                                                  state.filter.categories,
                                              statuses: state.filter.statuses,
                                            );
                                        context.read<PublicReportsBloc>().add(
                                          UpdatePublicFilter(updatedFilter),
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
                    if (state.status != PublicReportsStatus.success) {
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
            Navigate.push(context, PublicReportDetailPage(id: report.id));
          },
        );
      },
    );
  }
}
