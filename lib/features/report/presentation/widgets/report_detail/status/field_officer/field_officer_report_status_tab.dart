import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/widgets/card/information_card.dart';
import 'package:lapormin/features/report/domain/entities/field_check.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/card/field_check_card.dart';
import 'package:lapormin/features/report/presentation/widgets/card/final_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/loading/field_officer_report_status_tab_shimmer.dart';
import 'package:lapormin/features/report/presentation/widgets/report_detail/status/field_officer/field_officer_report_status_action.dart';
import 'package:lapormin/features/report/presentation/widgets/stepper/horizontal/horizontal_report_status_stepper.dart';

class FieldOfficerReportStatusTab extends StatefulWidget {
  final String id;

  const FieldOfficerReportStatusTab({super.key, required this.id});

  @override
  State<FieldOfficerReportStatusTab> createState() =>
      _FieldOfficerReportStatusTabState();
}

class _FieldOfficerReportStatusTabState
    extends State<FieldOfficerReportStatusTab> {
  bool _actionEnabled(InternalReportDetailState state) {
    final report = state.reportAggregate!.report;
    final fieldCheck = state.reportAggregate!.fieldCheck!;

    if (report.status == ReportStatus.fieldCheck) {
      return fieldCheck.description == null;
    }

    final finalReport = state.reportAggregate!.finalReport;
    if (report.status == ReportStatus.action) {
      return finalReport == null;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<InternalReportDetailBloc>().add(
          InternalReportDetailOpened(widget.id),
        );
        await Future.delayed(const Duration(seconds: 1));
      },
      child: BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
        builder: (context, state) {
          if (state.isLoading) return FieldOfficerReportStatusTabShimmer();

          final report = state.reportAggregate!.report;
          final fieldCheck = state.reportAggregate!.fieldCheck;
          final finalReport = state.reportAggregate!.finalReport;

          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 16,
                    children: [
                      HorizontalReportStatusStepper(
                        currentStatus: report.status,
                        dueDate: report.dueDate,
                      ),

                      if (fieldCheck != null)
                        ..._buildFieldCheckStatus(fieldCheck),

                      if (report.status == ReportStatus.rejected)
                        _buildRejectedInfoCard(),

                      if (finalReport != null)
                        FinalReportCard(finalReport: finalReport),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: FieldOfficerReportStatusAction(
              enabled: _actionEnabled(state),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildFieldCheckStatus(FieldCheck fieldCheck) {
    return [
      if (fieldCheck.description == null) _buildFieldOfficerInfoCard(),
      if (fieldCheck.description != null)
        FieldCheckCard(fieldCheck: fieldCheck),
    ];
  }

  Widget _buildFieldOfficerInfoCard() {
    return InformationCard(
      title: "Tindakan Petugas Lapangan",
      description:
          "Laporan ini menunggu hasil inspeksi kondisi lapangan untuk memastikan tidak adanya laporan palsu.",
      icon: Icons.work_history_outlined,
      type: InformationCardType.warning,
    );
  }

  Widget _buildRejectedInfoCard() {
    return InformationCard(
      title: "Laporan Ditolak",
      description:
          "Laporan telah ditolak karena alasan tertentu, penghapusan akan dilakukan dalam 3 hari.",
      icon: Icons.cancel_outlined,
      type: InformationCardType.danger,
    );
  }
}
