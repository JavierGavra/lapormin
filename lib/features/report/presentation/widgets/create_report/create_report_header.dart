import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../core/widgets/button/app_back_button.dart';
import '../../../../../core/widgets/progress_bar/segmented_progress_bar.dart';
import '../../bloc/create_report/create_report_bloc.dart';

class CreateReportHeader extends StatelessWidget {
  final int totalSteps;

  const CreateReportHeader({super.key, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocSelector<CreateReportBloc, CreateReportState, int>(
      selector: (state) => state.currentStep,
      builder: (context, currentStep) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 12, top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    AppBackButton(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Langkah $currentStep dari $totalSteps",
                          style: AppTextStyle.s12(color: color.secondary),
                        ),
                        Text(
                          "Buat Laporan",
                          style: AppTextStyle.s16(
                            fontWeight: FontWeight.w600,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SegmentedProgressBar(segment: totalSteps, progress: currentStep),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
