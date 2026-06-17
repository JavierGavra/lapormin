part of 'home_admin_bloc.dart';

enum HomeAdminStatus { initial, loading, success, failure }

class HomeAdminState extends Equatable {
  final HomeAdminStatus status;
  final List<ReportSummary> reports;

  final ReportStatistics? statistics;
  final String? errorMessage;

  const HomeAdminState({
    this.status = HomeAdminStatus.initial,
    this.reports = const [],
    this.statistics,
    this.errorMessage,
  });

  HomeAdminState copyWith({
    HomeAdminStatus? status,
    List<ReportSummary>? reports,
    ReportStatistics? statistics,
    String? errorMessage,
  }) {
    return HomeAdminState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      statistics: statistics ?? this.statistics,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, statistics, errorMessage];
}
