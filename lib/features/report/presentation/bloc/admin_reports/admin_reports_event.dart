part of 'admin_reports_bloc.dart';

sealed class AdminReportsEvent extends Equatable {
  const AdminReportsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchAdminReports extends AdminReportsEvent {
  final ReportCategory? category;
  final ReportStatus? status;
  final String? keyword;

  const FetchAdminReports({this.category, this.status, this.keyword});

  @override
  List<Object?> get props => [category, status, keyword];
}
