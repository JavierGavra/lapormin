part of 'public_reports_bloc.dart';

enum PublicReportsStatus { initial, loading, success, failure }

final class PublicReportsState extends Equatable {
  final PublicReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;
  final ReportFilterParams filter;

  const PublicReportsState({
    this.status = PublicReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
    this.filter = const ReportFilterParams(),
  });

  PublicReportsState copyWith({
    PublicReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
    ReportFilterParams? filter,
  }) {
    return PublicReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage, filter];
}
