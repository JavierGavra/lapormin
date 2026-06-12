import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'report_result_form_event.dart';
part 'report_result_form_state.dart';

class ReportResultFormBloc
    extends Bloc<ReportResultFormEvent, ReportResultFormState> {
  ReportResultFormBloc() : super(ReportResultFormState()) {
    on<ReportResultFormSubmitted>(_onReportResultFormSubmitted);
  }

  Future<void> _onReportResultFormSubmitted(
    ReportResultFormSubmitted event,
    Emitter<ReportResultFormState> emit,
  ) async {
    emit(ReportResultFormState(status: ReportResultFormStatus.loading));

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // On success
      emit(ReportResultFormState(status: ReportResultFormStatus.success));
    } catch (e) {
      emit(
        ReportResultFormState(
          status: ReportResultFormStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
