import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/card/information_card.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/card/field_check_card.dart';
import 'package:lapormin/features/report/presentation/widgets/card/final_report_card.dart';
import 'package:lapormin/features/report/presentation/widgets/input/due_action_field.dart';
import 'package:lapormin/features/report/presentation/widgets/report_detail/status/admin/admin_report_status_action.dart';
import 'package:lapormin/features/report/presentation/widgets/stepper/horizontal_report_status_stepper.dart';

class AdminReportStatusTab extends StatefulWidget {
  final String id;

  const AdminReportStatusTab({super.key, required this.id});

  @override
  State<AdminReportStatusTab> createState() => _AdminReportStatusTabState();
}

class _AdminReportStatusTabState extends State<AdminReportStatusTab> {
  final ValueNotifier<dynamic> _input = ValueNotifier<dynamic>(null);

  bool _actionEnabled(InternalReportDetailState state, dynamic value) {
    final report = state.reportAggregate!.report;
    if (report.status == ReportStatus.pending) {
      return value != null;
    }

    final fieldCheck = state.reportAggregate!.fieldCheck!;
    if (report.status == ReportStatus.fieldCheck) {
      return fieldCheck.description != null;
    }

    final finalReport = state.reportAggregate!.finalReport;
    if (report.status == ReportStatus.action) {
      return finalReport != null;
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
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

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

                      if (report.status == ReportStatus.pending) ...[
                        _buildFieldOfficerDropdown(),
                        _buildPendingInfoCard(),
                      ],

                      if (fieldCheck != null)
                        FieldCheckCard(fieldCheck: fieldCheck),

                      if (report.status == ReportStatus.verified)
                        DueActionField(
                          onChanged: (date) {
                            _input.value = date;
                          },
                        ),

                      if (finalReport != null)
                        FinalReportCard(finalReport: finalReport),

                      if (report.status == ReportStatus.rejected)
                        _buildRejectedInfoCard(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _input,
              builder: (context, value, child) {
                return AdminReportStatusAction(
                  input: value,
                  enabled: _actionEnabled(state, value),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldOfficerDropdown() {
    return DropdownButtonFormField<String>(
      items: [
        DropdownMenuItem(
          value: "9d599319-9303-4e06-a649-5e9c396eca74",
          child: Text("Rusdi Nasution"),
        ),
      ],
      onChanged: (value) {
        _input.value = value;
      },
      decoration: InputDecoration(
        labelText: "Pilih Petugas",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: AppTextStyle.s14(),
      ),
    );
  }

  Widget _buildPendingInfoCard() {
    return InformationCard(
      title: "Tindakan Admin",
      description:
          "Laporan ini menunggu peninjauan. Tugaskan petugas lapangan untuk melakukan pengecekan langsung ke lokasi sebelum melanjutkan ke tahap verifikasi.",
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
