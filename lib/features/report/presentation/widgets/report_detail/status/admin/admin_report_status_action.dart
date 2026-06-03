import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/widgets/button/app_filled_button.dart';
import 'package:lapormin/core/widgets/button/app_outlined_button.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';

class AdminReportStatusAction extends StatelessWidget {
  final bool enabled;
  final dynamic input;

  const AdminReportStatusAction({
    super.key,
    required this.enabled,
    required this.input,
  });

  void _onFieldCheckPressed(BuildContext context) {
    BlocProvider.of<InternalReportDetailBloc>(
      context,
    ).add(FieldCheckRequested(fieldOfficerId: input as String));
  }

  void _onVerifiedPressed(BuildContext context) {
    BlocProvider.of<InternalReportDetailBloc>(context).add(VerifiedRequested());
  }

  void _onRejectedPressed(BuildContext context) {
    BlocProvider.of<InternalReportDetailBloc>(context).add(RejectedRequested());
  }

  void _onActionPressed(BuildContext context) {
    BlocProvider.of<InternalReportDetailBloc>(
      context,
    ).add(ActionRequested(dueAction: input as DateTime?));
  }

  void _onDonePressed(BuildContext context) {
    BlocProvider.of<InternalReportDetailBloc>(context).add(DoneRequested());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
          builder: (context, state) {
            final status = state.reportAggregate!.report.status;

            switch (status) {
              case ReportStatus.pending:
                return AppFilledButton(
                  onPressed: enabled
                      ? () => _onFieldCheckPressed(context)
                      : null,
                  text: "Lakukan Cek Lapangan",
                  prefixIcon: Icons.search_rounded,
                );
              case ReportStatus.fieldCheck:
                return Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AppOutlinedButton(
                        enabled: enabled,
                        onPressed: enabled
                            ? () => _onRejectedPressed(context)
                            : null,
                        text: "Tolak",
                        foregroundColor: Colors.red,
                        prefixIcon: Icons.cancel_outlined,
                      ),
                    ),
                    Expanded(
                      child: AppFilledButton(
                        onPressed: enabled
                            ? () => _onVerifiedPressed(context)
                            : null,
                        text: "Verifikasi",
                        prefixIcon: Icons.check_circle_outline_rounded,
                      ),
                    ),
                  ],
                );
              case ReportStatus.verified:
                return AppFilledButton(
                  onPressed: enabled ? () => _onActionPressed(context) : null,
                  text: "Ambil Tindakan",
                  prefixIcon: Icons.build_rounded,
                );
              case ReportStatus.action:
                return AppFilledButton(
                  onPressed: enabled ? () => _onDonePressed(context) : null,
                  text: enabled ? "Tandai Selesai" : "Sedang Dalam Tindakan",
                  prefixIcon: Icons.done_all_rounded,
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
