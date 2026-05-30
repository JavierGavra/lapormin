part of 'public_report_detail_bloc.dart';

enum PublicReportDetailStatus { initial, loading, success, failure }

final class PublicReportDetailState extends Equatable {
  final PublicReportDetailStatus status;
  final Report? report;
  final String? errorMessage;

  const PublicReportDetailState({
    this.status = PublicReportDetailStatus.initial,
    this.report,
    this.errorMessage,
  });

  bool get isSuccess => status == PublicReportDetailStatus.success;

  PublicReportDetailState copyWith({
    PublicReportDetailStatus? status,
    Report? report,
    String? errorMessage,
  }) {
    return PublicReportDetailState(
      status: status ?? this.status,
      report: report ?? this.report,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, report, errorMessage];
}
