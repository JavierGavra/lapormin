part of 'admin_reports_bloc.dart';

enum AdminReportsStatus { initial, loading, success, failure }

final class AdminReportsState extends Equatable {
  final AdminReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;
  final ReportFilterParams filter;

  const AdminReportsState({
    this.status = AdminReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
    this.filter = const ReportFilterParams(),
  });

  AdminReportsState copyWith({
    AdminReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
    ReportFilterParams? filter,
  }) {
    return AdminReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage, filter];
}
