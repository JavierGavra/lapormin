import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/use_cases/submit_field_check.dart';
import 'package:lapormin/features/report/domain/use_cases/submit_final_report.dart';

part 'report_result_form_event.dart';
part 'report_result_form_state.dart';

class ReportResultFormBloc
    extends Bloc<ReportResultFormEvent, ReportResultFormState> {
  final SubmitFieldCheck _submitFieldCheck;
  final SubmitFinalReport _submitFinalReport;

  ReportResultFormBloc({
    required SubmitFieldCheck submitFieldCheck,
    required SubmitFinalReport submitFinalReport,
  }) : _submitFieldCheck = submitFieldCheck,
       _submitFinalReport = submitFinalReport,
       super(ReportResultFormState()) {
    on<ReportResultFormFieldCheckSubmitted>(
      _onReportResultFormFieldCheckSubmitted,
    );
    on<ReportResultFormFinalReportSubmitted>(
      _onReportResultFormFinalReportSubmitted,
    );
  }

  Future<void> _onReportResultFormFieldCheckSubmitted(
    ReportResultFormFieldCheckSubmitted event,
    Emitter<ReportResultFormState> emit,
  ) async {
    emit(ReportResultFormState(status: ReportResultFormStatus.loading));

    final result = await _submitFieldCheck(
      SubmitFieldCheckParams(
        fieldCheckId: event.fieldCheckId,
        description: event.description,
        evidences: event.evidences,
      ),
    );

    result.fold(
      (failure) => emit(
        ReportResultFormState(
          status: ReportResultFormStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        const ReportResultFormState(status: ReportResultFormStatus.success),
      ),
    );
  }

  Future<void> _onReportResultFormFinalReportSubmitted(
    ReportResultFormFinalReportSubmitted event,
    Emitter<ReportResultFormState> emit,
  ) async {
    emit(ReportResultFormState(status: ReportResultFormStatus.loading));

    final result = await _submitFinalReport(
      SubmitFinalReportParams(
        reportId: event.reportId,
        description: event.description,
        evidences: event.evidences,
      ),
    );

    result.fold(
      (failure) => emit(
        ReportResultFormState(
          status: ReportResultFormStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(
        const ReportResultFormState(status: ReportResultFormStatus.success),
      ),
    );
  }
}
