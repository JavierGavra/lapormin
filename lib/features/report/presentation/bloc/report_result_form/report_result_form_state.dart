part of 'report_result_form_bloc.dart';

enum ReportResultFormStatus { initial, loading, success, failure }

final class ReportResultFormState extends Equatable {
  final ReportResultFormStatus status;
  final String? errorMessage;

  bool get isLoading => status == ReportResultFormStatus.loading;
  bool get isSuccess => status == ReportResultFormStatus.success;
  bool get isFailure => status == ReportResultFormStatus.failure;

  const ReportResultFormState({
    this.status = ReportResultFormStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status, errorMessage ?? ''];
}
