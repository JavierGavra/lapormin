import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../home/presentation/widgets/location_banner/app_location_banner.dart';
import '../../../bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'grid_report_info_evidences.dart';
import 'report_info_description.dart';
import 'report_info_header.dart';
import 'report_info_map.dart';
import 'report_info_tags.dart';

class ReportInfoTab extends StatelessWidget {
  const ReportInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
      builder: (context, state) {
        if (!state.isSuccess) return Center(child: CircularProgressIndicator());

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
                  ReportInfoTags(ticket: report.ticket, status: report.status),
                  ReportInfoHeader(
                    title: report.title,
                    createdAt: report.createdAt,
                    category: report.category,
                  ),
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
    );
  }
}
