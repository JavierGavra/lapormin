import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:lapormin/features/report/presentation/widgets/chip/custom_chip.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../home/presentation/widgets/location_banner/app_location_banner.dart';
import '../../../bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'grid_report_info_evidences.dart';
import 'report_info_description.dart';
import 'report_info_header.dart';
import 'report_info_map.dart';
import 'report_info_tags.dart';

class ReportInfoTab extends StatelessWidget {
  final String id;

  const ReportInfoTab({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InternalReportDetailBloc>().add(
          InternalReportDetailOpened(id),
        );

        await Future.delayed(const Duration(seconds: 1));
      },
      child: BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final report = state.reportAggregate!.report;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SafeArea(
                top: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    ReportInfoTags(
                      ticket: report.ticket,
                      status: report.status,
                    ),
                    ReportInfoHeader(
                      title: report.title,
                      createdAt: report.createdAt,
                      category: report.category,
                    ),
                    if (report.status == ReportStatus.action)
                      _buildDueChip(color, report),
                    LocationBanner(location: report.address, isSmall: true),
                    ReportInfoDescription(description: report.description),
                    GridReportInfoEvidences(evidences: report.evidences),
                    ReportInfoMap(
                      withTitle: true,
                      position: LatLng(report.latitude, report.longitude),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDueChip(ColorScheme color, Report report) {
    return CustomChip(
      vertical: 4,
      backgroundColor: color.error,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(Icons.calendar_month_outlined, size: 16, color: color.onError),
          Text(
            "Tenggat : ${report.dueDate != null ? DateFormat('dd MMMM yyyy', 'id_ID').format(report.dueDate!) : "Tidak ada batas waktu"}",
            style: AppTextStyle.s12(color: color.onError),
          ),
        ],
      ),
    );
  }
}
