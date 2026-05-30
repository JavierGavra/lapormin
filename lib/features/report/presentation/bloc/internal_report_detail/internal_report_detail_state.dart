part of 'internal_report_detail_bloc.dart';

enum InternalReportDetailStatus { initial, loading, success, failure }

final class InternalReportDetailState extends Equatable {
  final InternalReportDetailStatus status;
  final ReportStatus reportStatus;
  final ReportAggregate? reportAggregate;
  final String? errorMessage;

  const InternalReportDetailState({
    this.status = InternalReportDetailStatus.initial,
    this.reportStatus = ReportStatus.pending,
    this.reportAggregate,
    this.errorMessage,
  });

  bool get isLoading => status == InternalReportDetailStatus.loading;
  bool get isSuccess => status == InternalReportDetailStatus.success;

  InternalReportDetailState copyWith({
    InternalReportDetailStatus? status,
    ReportStatus? reportStatus,
    ReportAggregate? reportAggregate,
    String? errorMessage,
  }) {
    return InternalReportDetailState(
      status: status ?? this.status,
      reportStatus: reportStatus ?? this.reportStatus,
      reportAggregate: reportAggregate ?? this.reportAggregate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reportStatus,
    reportAggregate,
    errorMessage,
  ];
}
