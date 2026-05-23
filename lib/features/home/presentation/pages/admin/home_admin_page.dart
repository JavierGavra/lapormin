import 'package:flutter/material.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/home/presentation/widgets/location_banner/app_location_banner.dart';
import 'package:lapormin/core/widgets/quick_info_card/quick_info_card.dart';

import 'package:lapormin/features/home/presentation/widgets/admin_home_greeting/admin_home_greeting.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({super.key});

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
                debugPrint("Buka notifikasi admin");
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
                    const AdminHomeGreeting(),
                    const SizedBox(height: 24),

                    LocationBanner(
                      location: 'Semarang',
                      onTap: () {
                        debugPrint("Ganti Lokasi Admin");
                      },
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.pending_actions,
                            title: "Menunggu Verifikasi",
                            count: "12",
                            backgroundColor: color.surface,
                            iconBackgroundColor: color.primaryContainer,
                            iconColor: color.onPrimaryContainer,
                            textColor: color.primary,
                            titleColor: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.cached,
                            title: "Sedang Diproses",
                            count: "5",
                            backgroundColor: color.surface,
                            iconBackgroundColor: color.tertiaryContainer,
                            iconColor: color.onTertiaryContainer,
                            textColor: color.tertiary,
                            titleColor: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.task_alt,
                            title: "Laporan Selesai",
                            count: "3",
                            backgroundColor: color.surface,
                            iconBackgroundColor: color.successContainer,
                            iconColor: color.onSuccessContainer,
                            textColor: color.success,
                            titleColor: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: AdminQuickInfoCard(
                            iconData: Icons.description_outlined,
                            title: "Total Laporan",
                            count: "20",
                            backgroundColor: color.primary,
                            iconBackgroundColor: color.surfaceContainerLowest,
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
                          "Laporan Terbaru",
                          style: AppTextStyle.s16(fontWeight: FontWeight.w600),
                        ),
                        Row(
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
                      ],
                    ),
                    const SizedBox(height: 16),

                    ReportCard(
                      imageUrl: 'assets/images/cards/jlnberlubang.png',
                      title: "Jalan Berlubang di Jl. Sudirman",
                      location: "Jl. Gatot Subroto",
                      timeAgo: "2 jam lalu",
                      status: ReportStatus.pending,
                      categoryIcon: Icons.apartment_outlined,
                      categoryColor: color.primaryContainer,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      imageUrl: 'assets/images/cards/kriminal.png',
                      title: "Pencurian motor",
                      location: "Jl. Merdeka No. 12",
                      timeAgo: "1 hari lalu",
                      status: ReportStatus.fieldCheck,
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
                      status: ReportStatus.action,
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
