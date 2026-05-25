import 'package:flutter/material.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/home/presentation/widgets/location_banner/app_location_banner.dart';
import 'package:lapormin/core/widgets/quick_info_card/quick_info_card.dart';
import 'package:lapormin/features/home/presentation/widgets/field_officer_home_greeting/field_officer_home_greeting.dart';
import 'package:lapormin/features/report/presentation/pages/field_officer_report_listt_page.dart';

class HomeFieldOfficerPage extends StatelessWidget {
  final VoidCallback onNavigateToReports;
  const HomeFieldOfficerPage({super.key, required this.onNavigateToReports});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppSliverAppBar(
              profileUrl: "assets/images/profiles/profile.png",
              onNotificationTap: () {
                debugPrint("Buka notifikasi petugas");
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FieldOfficerHomeGreeting(),
                    const SizedBox(height: 24),

                    LocationBanner(
                      location: 'Semarang',
                      onTap: () {
                        debugPrint("Pilih lokasi petugas");
                      },
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.content_paste_search_outlined,
                            title: "Inspeksi",
                            count: "1",
                            backgroundColor: Colors.white,
                            iconBackgroundColor: color.warningContainer,
                            iconColor: color.onWarningContainer,
                            textColor: color.warning,
                            titleColor: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.build_outlined,
                            title: "Tindakan",
                            count: "1",
                            backgroundColor: Colors.white,
                            iconBackgroundColor: color.tertiaryContainer,
                            iconColor: color.onTertiaryContainer,
                            textColor: color.tertiary,
                            titleColor: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.assignment_outlined,
                            title: "Penugasan",
                            count: "2",
                            backgroundColor: color.primary,
                            iconBackgroundColor: Colors.white,
                            iconColor: color.primary,
                            textColor: color.onPrimary,
                            titleColor: color.surfaceContainerHigh,
                            isLargeText: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const SizedBox(height: 26),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Penugasan Terbaru",
                          style: AppTextStyle.s16(fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FieldOfficerReportListPage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: onNavigateToReports,
                                child: Text(
                                  "Lihat Semua",
                                  style: AppTextStyle.s14(
                                    color: color.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                    const SizedBox(height: 16),

                    ReportCard(
                      imageUrl: 'assets/images/cards/kriminal.png',
                      title: "Pencurian motor",
                      location: "Jl. Merdeka No. 12",
                      timeAgo: "1 hari lalu",
                      status: ReportStatus.action,
                      deadlineDate: DateTime(2026, 9, 20),
                      categoryIcon: Icons.warning_amber_rounded,
                      categoryColor: color.errorContainer,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      imageUrl: 'assets/images/cards/banjir.png',
                      title: "Banjir di area perumahan",
                      location: "Perumahan griya indah",
                      timeAgo: "3 hari lalu",
                      status: ReportStatus.done,
                      categoryIcon: Icons.flood_outlined,
                      categoryColor: color.warningContainer,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
