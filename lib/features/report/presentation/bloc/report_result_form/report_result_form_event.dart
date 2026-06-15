part of 'report_result_form_bloc.dart';

sealed class ReportResultFormEvent extends Equatable {
  const ReportResultFormEvent();

  @override
  List<Object> get props => [];
}

final class ReportResultFormFieldCheckSubmitted extends ReportResultFormEvent {
  final String fieldCheckId;
  final String description;
  final List<String> evidences;

  const ReportResultFormFieldCheckSubmitted({
    required this.fieldCheckId,
    required this.description,
    required this.evidences,
  });

  @override
  List<Object> get props => [fieldCheckId, description, evidences];
}

final class ReportResultFormFinalReportSubmitted extends ReportResultFormEvent {
  final String reportId;
  final String description;
  final List<String> evidences;

  const ReportResultFormFinalReportSubmitted({
    required this.reportId,
    required this.description,
    required this.evidences,
  });

  @override
  List<Object> get props => [reportId, description, evidences];
}
