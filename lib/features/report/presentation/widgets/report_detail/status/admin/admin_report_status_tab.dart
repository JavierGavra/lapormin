import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/card/field_check_card.dart';
import 'package:lapormin/features/report/presentation/widgets/stepper/horizontal_report_status_stepper.dart';

class AdminReportStatusTab extends StatelessWidget {
  const AdminReportStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
      builder: (context, state) {
        if (!state.isSuccess) return Center(child: CircularProgressIndicator());

        final report = state.reportAggregate!.report;
        final fieldCheck = state.reportAggregate!.fieldCheck;
        // final finalReport = state.reportAggregate!.finalReport;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                    FieldCheckCard(fieldCheck: fieldCheck),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
