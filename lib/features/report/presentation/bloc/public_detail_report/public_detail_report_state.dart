part of 'public_detail_report_bloc.dart';

enum PublicDetailReportStatus { initial, loading, success, failure }

final class PublicDetailReportState extends Equatable {
  final PublicDetailReportStatus status;
  final Report? report;
  final String? errorMessage;

  const PublicDetailReportState({
    this.status = PublicDetailReportStatus.initial,
    this.report,
    this.errorMessage,
  });

  bool get isSuccess => status == PublicDetailReportStatus.success;

  PublicDetailReportState copyWith({
    PublicDetailReportStatus? status,
    Report? report,
    String? errorMessage,
  }) {
    return PublicDetailReportState(
      status: status ?? this.status,
      report: report ?? this.report,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, report, errorMessage];
}
