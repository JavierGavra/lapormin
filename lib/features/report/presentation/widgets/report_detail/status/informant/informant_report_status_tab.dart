import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/stepper/vertical/vertical_report_status_stepper.dart';

class InformantReportStatusTab extends StatelessWidget {
  const InformantReportStatusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<InternalReportDetailBloc, InternalReportDetailState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Text(
                  "Riwayat Status",
                  style: AppTextStyle.s16(fontWeight: FontWeight.w600),
                ),
                VerticalReportStatusStepper(
                  reportAggregate: state.reportAggregate!,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
