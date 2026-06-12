part of 'report_result_form_bloc.dart';

sealed class ReportResultFormEvent extends Equatable {
  const ReportResultFormEvent();

  @override
  List<Object> get props => [];
}

final class ReportResultFormSubmitted extends ReportResultFormEvent {
  final String reportId;
  final String description;
  final List<String> evidences;

  const ReportResultFormSubmitted({
    required this.reportId,
    required this.description,
    required this.evidences,
  });

  @override
  List<Object> get props => [reportId, description, evidences];
}
