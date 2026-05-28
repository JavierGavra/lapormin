part of 'public_reports_bloc.dart';

enum PublicReportsStatus { initial, loading, success, failure }

final class PublicReportsState extends Equatable {
  final PublicReportsStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;

  const PublicReportsState({
    this.status = PublicReportsStatus.initial,
    this.reports = const [],
    this.errorMessage,
  });

  PublicReportsState copyWith({
    PublicReportsStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
  }) {
    return PublicReportsState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage];
}
