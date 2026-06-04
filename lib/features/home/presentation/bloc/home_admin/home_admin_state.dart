part of 'home_admin_bloc.dart';

enum HomeAdminStatus { initial, loading, success, failure }

class HomeAdminState extends Equatable {
  final HomeAdminStatus status;
  final List<ReportSummary> reports;
  final String? errorMessage;

  const HomeAdminState({
    this.status = HomeAdminStatus.initial,
    this.reports = const [],
    this.errorMessage,
  });

  HomeAdminState copyWith({
    HomeAdminStatus? status,
    List<ReportSummary>? reports,
    String? errorMessage,
  }) {
    return HomeAdminState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage];
}
