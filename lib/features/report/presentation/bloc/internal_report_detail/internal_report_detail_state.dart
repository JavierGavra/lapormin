part of 'internal_report_detail_bloc.dart';

enum InternalReportDetailStatus {
  initial,
  loading,
  overlayLoading,
  success,
  deleted,
  failure,
}

final class InternalReportDetailState extends Equatable {
  final InternalReportDetailStatus status;
  final ReportStatus reportStatus;
  final ReportAggregate? reportAggregate;
  final String? errorMessage;

  // Hanya digunakan pada Admin saat status "Pending"
  final List<FieldOfficer>? fieldOfficers;

  const InternalReportDetailState({
    this.status = InternalReportDetailStatus.initial,
    this.reportStatus = ReportStatus.pending,
    this.reportAggregate,
    this.fieldOfficers,
    this.errorMessage,
  });

  bool get isLoading =>
      status == InternalReportDetailStatus.loading ||
      status == InternalReportDetailStatus.initial;

  bool get isOverlayLoading =>
      status == InternalReportDetailStatus.overlayLoading;

  bool get isSuccess => status == InternalReportDetailStatus.success;

  InternalReportDetailState copyWith({
    InternalReportDetailStatus? status,
    ReportStatus? reportStatus,
    ReportAggregate? reportAggregate,
    List<FieldOfficer>? fieldOfficers,
    String? errorMessage,
  }) {
    return InternalReportDetailState(
      status: status ?? this.status,
      reportStatus: reportStatus ?? this.reportStatus,
      reportAggregate: reportAggregate ?? this.reportAggregate,
      fieldOfficers: fieldOfficers ?? this.fieldOfficers,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reportStatus,
    reportAggregate,
    fieldOfficers,
    errorMessage,
  ];
}
