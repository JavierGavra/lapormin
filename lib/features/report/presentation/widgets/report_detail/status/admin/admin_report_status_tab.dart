import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/report_status_enum.dart';
import '../../../../../../../core/utils/phone_number/phone_number_format.dart';
import '../../../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../../../core/widgets/card/information_card.dart';
import '../../../../../../field_officer/domain/entities/field_officer.dart';
import '../../../../bloc/internal_report_detail/internal_report_detail_bloc.dart';
import '../../../card/field_check_card.dart';
import '../../../card/final_report_card.dart';
import '../../../input/due_action_field.dart';
import '../../../loading/admin_report_status_tab_shimmer.dart';
import '../../../stepper/horizontal/horizontal_report_status_stepper.dart';
import 'admin_report_status_action.dart';

class AdminReportStatusTab extends StatefulWidget {
  final String id;

  const AdminReportStatusTab({super.key, required this.id});

  @override
  State<AdminReportStatusTab> createState() => _AdminReportStatusTabState();
}

class _AdminReportStatusTabState extends State<AdminReportStatusTab> {
  final _fieldOfficer = ValueNotifier<FieldOfficer?>(null);
  final _input = ValueNotifier<dynamic>(null);

  void _onFieldOfficerRemoved() {
    _fieldOfficer.value = null;
    _input.value = null;
  }

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
          if (state.isLoading) return AdminReportStatusTabShimmer();

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

                      if (report.status == ReportStatus.pending)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildFieldOfficerDropdown(
                              state.fieldOfficers ?? [],
                            ),
                            const SizedBox(height: 16),
                            _buildFieldOfficerCard(),
                            _buildPendingInfoCard(),
                          ],
                        ),

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

  Widget _buildFieldOfficerDropdown(List<FieldOfficer> fieldOfficers) {
    return ValueListenableBuilder(
      valueListenable: _fieldOfficer,
      builder: (context, value, child) {
        return DropdownButtonFormField<FieldOfficer>(
          initialValue: value,
          items: fieldOfficers.map((officer) {
            return DropdownMenuItem(value: officer, child: Text(officer.name));
          }).toList(),
          onChanged: (value) {
            _input.value = value?.id;
            _fieldOfficer.value = value;
          },
          decoration: InputDecoration(
            labelText: "Pilih Petugas",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintStyle: AppTextStyle.s14(),
          ),
        );
      },
    );
  }

  Widget _buildFieldOfficerCard() {
    return ValueListenableBuilder(
      valueListenable: _fieldOfficer,
      builder: (context, officer, _) {
        final color = Theme.of(context).colorScheme;

        if (officer == null) return SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: color.primaryContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.primary),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    officer.initial,
                    style: AppTextStyle.s16(
                      fontWeight: FontWeight.w600,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      officer.name,
                      style: AppTextStyle.s14(
                        fontWeight: FontWeight.w600,
                        color: color.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      PhoneNumberFormat.formatted(officer.phone),
                      style: AppTextStyle.s12(color: color.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _onFieldOfficerRemoved,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16,
                    color: color.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
