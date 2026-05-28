part of 'admin_reports_bloc.dart';

enum AdminReportsStatus { initial, loading, success, failure }

final class AdminReportsState extends Equatable {
  final AdminReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;

  const AdminReportsState({
    this.status = AdminReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
  });

  AdminReportsState copyWith({
    AdminReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
  }) {
    return AdminReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage];
}
