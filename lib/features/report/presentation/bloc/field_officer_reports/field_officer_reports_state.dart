part of 'field_officer_reports_bloc.dart';

enum FieldOfficerReportsStatus { initial, loading, success, failure }

final class FieldOfficerReportsState extends Equatable {
  final FieldOfficerReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;
  final ReportFilterParams filter;

  const FieldOfficerReportsState({
    this.status = FieldOfficerReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
    this.filter = const ReportFilterParams(),
  });

  FieldOfficerReportsState copyWith({
    FieldOfficerReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
    ReportFilterParams? filter,
  }) {
    return FieldOfficerReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage, filter];
}
