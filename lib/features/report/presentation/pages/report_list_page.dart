import 'package:flutter/material.dart';
import 'package:lapormin/core/theme/theme.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/my_report_fab.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  bool _isStyle1 = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      floatingActionButton: MyReportFab(
        onTap: () {
          debugPrint("Menuju halaman laporanku");
          // TODO: Navigasi ke halaman MyReportPage
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            AppSliverAppBar(
              profileUrl: "assets/images/profiles/profile.png",
              onNotificationTap: () {
                debugPrint("Buka Notifikasi Laporan");
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
                    Row(
                      children: [
                        Expanded(
                          child: ReportSearchBar(
                            onSearchTap: () {
                              debugPrint("Buka halaman cari");
                            },
                            onFilterTap: () {
                              debugPrint("Buka Modal Filter pencarian");
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
                    const SizedBox(height: 24),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      // 👉 INI DIA PEMANGGILANNYA (MEMILIH ANTARA 2 METHOD DI BAWAH)
                      child: _isStyle1
                          ? _buildStyle1List(color)
                          : _buildStyle2List(color),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // VIEW: STYLE 1 (GAMBAR BESAR)
  // ==========================================
  Widget _buildStyle1List(ColorScheme color) {
    return Column(
      key: const ValueKey("Style1"),
      children: [
        ReportCard(
          imageUrl: 'assets/images/cards/jlnberlubang.png',
          title: "Jalan Berlubang di Jl. Sudirman",
          location: "Jl. Gatot subroto",
          timeAgo: "2 jam lalu",
          status: ReportStatus.verified,
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
    );
  }

  // ==========================================
  // VIEW: STYLE 2 (RINGKAS TANPA GAMBAR)
  // ==========================================
  Widget _buildStyle2List(ColorScheme color) {
    return Column(
      key: const ValueKey("Style2"), // Key penting untuk animasi switch
      children: [
        CompactReportCard(
          title: "Jalan Berlubang di Jl. Sudirman",
          location: "Jl. Sudirman No. 45",
          timeAgo: "2 jam lalu",
          status: ReportStatus.pending,
          onTap: () {},
        ),
        // Jarak antar card style ringkas biasanya lebih rapat (12px)
        const SizedBox(height: 12),
        CompactReportCard(
          title: "Pencurian motor",
          location: "Jl. Merdeka No. 12",
          timeAgo: "1 hari lalu",
          status: ReportStatus.fieldCheck,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        CompactReportCard(
          title: "Banjir di area perumahan",
          location: "Perumahan griya indah",
          timeAgo: "3 hari lalu",
          status: ReportStatus.action,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        CompactReportCard(
          title: "Lampu pertigaan mati",
          location: "Jl. Gatot subroto",
          timeAgo: "17 Juli 2025",
          status: ReportStatus.done,
          onTap: () {},
        ),
      ],
    );
  }
}
