import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/widgets/button/app_filled_button.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'package:lapormin/features/report/presentation/pages/report_result_form_page.dart';

class FieldOfficerReportStatusAction extends StatelessWidget {
  final bool enabled;
  const FieldOfficerReportStatusAction({super.key, required this.enabled});

  void _onSubmitPressed(
    BuildContext context,
    Report report,
    String? fieldCheckId,
  ) async {
    final isSubmitSuccess = await Navigate.push<bool?>(
      context,
      ReportResultFormPage(
        type: report.status == ReportStatus.fieldCheck
            ? ReportResultFormType.fieldCheck
            : ReportResultFormType.action,
        reportTitle: report.title,
        fieldCheckId: fieldCheckId,
      ),
    );
    if (isSubmitSuccess == true && context.mounted) {
      context.read<InternalReportDetailBloc>().add(
        InternalReportDetailOpened(report.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
          builder: (context, state) {
            final report = state.reportAggregate!.report;
            final status = report.status;

            switch (status) {
              case ReportStatus.pending:
                return AppFilledButton(
                  onPressed: null,
                  text: "Belum Ada Penugasan",
                  prefixIcon: Icons.search_rounded,
                );
              case ReportStatus.fieldCheck:
                return AppFilledButton(
                  onPressed: enabled
                      ? () => _onSubmitPressed(
                          context,
                          report,
                          state.reportAggregate!.fieldCheck?.id,
                        )
                      : null,
                  text: enabled ? "Buat Hasil Inspeksi" : "Menunggu Verifikasi",
                  prefixIcon: enabled ? Icons.description_outlined : null,
                );
              case ReportStatus.verified:
                return AppFilledButton(
                  onPressed: null,
                  text: "Menunggu Instruksi Tindakan",
                  prefixIcon: null,
                );
              case ReportStatus.action:
                return AppFilledButton(
                  onPressed: enabled
                      ? () => _onSubmitPressed(context, report, null)
                      : null,
                  text: enabled ? "Buat Laporan Akhir" : "Menunggu Validasi",
                  prefixIcon: enabled ? Icons.description_outlined : null,
                );
              default:
                return AppFilledButton(
                  onPressed: null,
                  text: "Dihapus Dalam 7 Hari",
                  prefixIcon: Icons.auto_delete_outlined,
                );
            }
          },
        ),
      ),
    );
  }
}
