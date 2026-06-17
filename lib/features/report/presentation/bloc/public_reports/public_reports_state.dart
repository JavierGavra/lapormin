part of 'public_reports_bloc.dart';

enum PublicReportsStatus { initial, loading, success, failure }

class PublicReportsState extends Equatable {
  final PublicReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;
  final ReportFilterParams filter;
  final String? location;
  final String? username;

  const PublicReportsState({
    this.status = PublicReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
    this.filter = const ReportFilterParams(),
    this.location,
    this.username,
  });

  PublicReportsState copyWith({
    PublicReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
    ReportFilterParams? filter,
    String? location,
    String? username,
  }) {
    return PublicReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
      location: location ?? this.location,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reports,
    errorMessage,
    filter,
    location,
    username,
  ];
}
