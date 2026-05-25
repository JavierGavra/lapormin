import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';

class FieldOfficerReportListPage extends StatefulWidget {
  const FieldOfficerReportListPage({super.key});

  @override
  State<FieldOfficerReportListPage> createState() =>
      _FieldOfficerReportListPageState();
}

class _FieldOfficerReportListPageState
    extends State<FieldOfficerReportListPage> {
  bool _isStyle1 = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: CustomScrollView(
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
                  Row(
                    children: [
                      Expanded(
                        child: ReportSearchBar(
                          onSearchTap: () => debugPrint("Cari penugasan"),
                          onFilterTap: () => debugPrint("Filter penugasan"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ReportLayoutSwitch(
                        isStyle1: _isStyle1,
                        onSwitch: (val) => setState(() => _isStyle1 = val),
                      ),
                    ],
                  ),
                  _buildReportList(color),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportList(ColorScheme color) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _isStyle1 ? _buildStyle1List(color) : _buildStyle2List(color),
    );
  }

  Widget _buildStyle1List(ColorScheme color) {
    return ListView.separated(
      key: const ValueKey("Style1"),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return ReportCard(
          imageUrl: 'assets/images/cards/kriminal.png',
          title: "Pencurian motor",
          location: "Jl. Merdeka No. 12",
          timeAgo: "1 hari lalu",
          status: ReportStatus.action,
          deadlineDate: DateTime.now().add(const Duration(days: 3)),
          categoryIcon: ReportCategory.crime.icon,
          categoryColor: color.errorContainer,
          onTap: () => debugPrint("Detail Penugasan diklik"),
        );
      },
    );
  }

  Widget _buildStyle2List(ColorScheme color) {
    return ListView.separated(
      key: const ValueKey("Style2"),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return CompactReportCard(
          title: "Pencurian motor",
          location: "Jl. Merdeka No. 12222",
          timeAgo: "1 hari lalu",
          status: ReportStatus.action,
          deadlineDate: DateTime.now().add(const Duration(days: 3)),
          onTap: () => debugPrint("Detail Penugasan diklik"),
        );
      },
    );
  }
}
