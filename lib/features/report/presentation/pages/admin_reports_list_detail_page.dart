import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/report_card/report_card.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/features/report/presentation/widgets/admin_report/admin_sliver_app_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/compact_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_search_bar.dart';
import 'package:lapormin/features/report/presentation/widgets/report_list/report_layout_switch.dart';

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

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: CustomScrollView(
        slivers: [
          AdminSliverAppBar(
            title: widget.title,
            onBackTap: () => Navigator.pop(context),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ReportSearchBar(
                          onSearchTap: () => debugPrint("Cari laporan admin"),
                          onFilterTap: () => debugPrint("Filter admin"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ReportLayoutSwitch(
                        isStyle1: _isStyle1,
                        onSwitch: (val) => setState(() => _isStyle1 = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isStyle1
                        ? _buildStyle1List(color)
                        : _buildStyle2List(color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyle1List(ColorScheme color) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      key: const ValueKey("Style1"),
      children: [
        ReportCard(
          imageUrl: 'assets/images/cards/jlnberlubang.png',
          title: "Jalan Berlubang di Jl. Sudirman",
          location: "Jl. Gatot subroto",
          timeAgo: "2 jam lalu",
          status: ReportStatus.verified,
          categoryIcon: ReportCategory.infrastructure.icon,
          categoryColor: color.primaryContainer,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildStyle2List(ColorScheme color) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      key: const ValueKey("Style2"),
      children: [
        CompactReportCard(
          title: "Jalan Berlubang di Jl. Sudirman",
          location: "Jl. Sudirman No. 45",
          timeAgo: "2 jam lalu",
          status: ReportStatus.pending,
          onTap: () {},
        ),
      ],
    );
  }
}
