import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/home/presentation/widgets/home_greeting/home_greeting.dart';
import 'package:lapormin/features/home/presentation/widgets/category_card/category_card.dart';
import 'package:lapormin/core/widgets/card/report_card.dart';
import 'package:lapormin/features/home/presentation/widgets/hero_button/hero_button.dart';
import 'package:lapormin/features/report/presentation/pages/create_report_page.dart';
import 'package:lapormin/features/report/presentation/pages/public_report_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:lapormin/features/report/presentation/bloc/public_reports/public_reports_bloc.dart';
import 'package:lapormin/core/widgets/loading/report_card_shimmer.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onSeeAllTapped;
  const HomePage({super.key, this.onSeeAllTapped});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _onRefresh() async {
    context.read<PublicReportsBloc>().add(const FetchPublicReports());
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocSelector<
                          PublicReportsBloc,
                          PublicReportsState,
                          (String?, String?)
                        >(
                          selector: (state) => (state.username, state.location),
                          builder: (context, data) {
                            final displayUserName = data.$1 ?? "Warga...";
                            final displayLocation =
                                data.$2 ?? "Mencari lokasi...";

                            return HomeGreeting(
                              userName: displayUserName,
                              location: displayLocation,
                            );
                          },
                        ),

                        const SizedBox(height: 24),
                        HeroButton(
                          label: "Buat Laporan",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CreateReportPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Kategori",
                          style: AppTextStyle.s14(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CategoryCard(
                              icon: Icons.apartment_outlined,
                              title: "Infrastruktur",
                              backgroundColor: color.primaryContainer,
                              iconColor: color.onPrimaryContainer,
                              onTap: () => debugPrint("Menu Infrastruktur"),
                            ),
                            CategoryCard(
                              icon: Icons.flood_outlined,
                              title: "Bencana",
                              backgroundColor: color.warningContainer,
                              iconColor: color.onTertiaryContainer,
                              onTap: () => debugPrint("Menu Bencana"),
                            ),
                            CategoryCard(
                              icon: Icons.warning_amber_rounded,
                              title: "Kriminal",
                              backgroundColor: color.errorContainer,
                              iconColor: color.onErrorContainer,
                              onTap: () => debugPrint("Menu Kriminal"),
                            ),
                            CategoryCard(
                              icon: Icons.account_balance_outlined,
                              title: "Layanan Publik",
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.successContainer,
                              iconColor: Theme.of(
                                context,
                              ).colorScheme.onSuccessContainer,
                              onTap: () => debugPrint("Menu Layanan Publik"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Laporan Terbaru",
                              style: AppTextStyle.s16(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.onSeeAllTapped,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Lihat Semua",
                                    style: AppTextStyle.s14(
                                      color: color.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: color.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<PublicReportsBloc, PublicReportsState>(
                  builder: (context, state) {
                    if (state.status != PublicReportsStatus.success) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: List.generate(
                              3,
                              (index) => const Padding(
                                padding: EdgeInsets.only(bottom: 16.0),
                                child: ReportCardShimmer(),
                              ),
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
                            child: Text("Belum ada laporan di areamu."),
                          ),
                        ),
                      );
                    }

                    final displayReports = state.reports.take(5).toList();

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverList.separated(
                        itemCount: displayReports.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final report = displayReports[index];
                          final category = ReportCategory.fromString(
                            report.category,
                          );

                          timeago.setLocaleMessages('id', timeago.IdMessages());
                          final timeAgoText = timeago.format(
                            report.createdAt,
                            locale: 'id',
                          );

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
                              Navigate.push(
                                context,
                                PublicReportDetailPage(id: report.id),
                              );
                            },
                          );
                        },
                      ),
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
}
