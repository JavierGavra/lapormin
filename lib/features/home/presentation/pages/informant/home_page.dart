import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/features/home/presentation/widgets/home_greeting/home_greeting.dart';
import 'package:lapormin/features/home/presentation/widgets/category_card/category_card.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/features/home/presentation/widgets/hero_button/hero_button.dart';
import 'package:lapormin/features/report/presentation/pages/create_report_page.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                debugPrint("Buka notifikasi");
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
                    const HomeGreeting(
                      userName: "Brooklyn Simmons",
                      location: "Semarang",
                    ),
                    const SizedBox(height: 24),

                    HeroButton(
                      label: "Buat Laporan",
                      onTap: () {
                        context.pushTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const CreateReportPage(),
                        );
                        debugPrint("Tombol Buat Laporan Diklik!");
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
                          onTap: () {
                            debugPrint("Menu Infrastruktur");
                          },
                        ),

                        CategoryCard(
                          icon: Icons.flood_outlined,
                          title: "Bencana",
                          backgroundColor: color.warningContainer,
                          iconColor: color.onTertiaryContainer,
                          onTap: () {
                            debugPrint("Menu Bencana");
                          },
                        ),

                        CategoryCard(
                          icon: Icons.warning_amber_rounded,
                          title: "Kriminal",
                          backgroundColor: color.errorContainer,
                          iconColor: color.onErrorContainer,
                          onTap: () {
                            debugPrint("Menu Kriminal");
                          },
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
                          onTap: () {
                            debugPrint("Menu Layanan Publik");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Laporan Terbaru",
                          style: AppTextStyle.s14(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "Lihat Semua >",
                          style: AppTextStyle.s12(
                            color: color.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    ReportCard(
                      imageUrl: 'assets/images/cards/jlnberlubang.png',
                      title: "Jalan Berlubang di Jl. Sudirman",
                      location: "Jl. Gatot Subroto",
                      timeAgo: "2 jam lalu",
                      status: ReportStatus.verified,
                      categoryIcon: Icons.apartment_outlined,
                      categoryColor: color.primaryContainer,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      imageUrl: 'assets/images/cards/kriminal.png',
                      title: "Pencurian Motor ",
                      location: "Jl. Merdeka No.12",
                      timeAgo: "1 hari lalu",
                      status: ReportStatus.fieldCheck,
                      categoryIcon: Icons.warning_amber_rounded,
                      categoryColor: color.errorContainer,
                      isVideo: true,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      imageUrl: 'assets/images/cards/banjir.png',
                      title: "Banjir di Area Perumahan",
                      location: "Perumahan Griya Indah",
                      timeAgo: "3 hari lalu",
                      status: ReportStatus.action,
                      categoryIcon: Icons.flood_outlined,
                      categoryColor: color.warningContainer,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    ReportCard(
                      imageUrl: 'assets/images/cards/infrastruktur.png',
                      title: "Lampu Pertigaan Mati",
                      location: "Jl. Gatot Subroto",
                      timeAgo: "17 Juli 2025",
                      status: ReportStatus.done,
                      categoryIcon: Icons.account_balance_outlined,
                      categoryColor: color.successContainer,
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
