import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/presentation/bloc/internal_report_detail/internal_report_detail_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/stepper/vertical/vertical_report_status_stepper.dart';

class InformantReportStatusTab extends StatelessWidget {
  final String id;

  const InformantReportStatusTab({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
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

          return SingleChildScrollView(
            child: Padding(
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
            ),
          );
        },
      ),
    );
  }
}
