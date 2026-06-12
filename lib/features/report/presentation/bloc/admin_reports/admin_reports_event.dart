part of 'admin_reports_bloc.dart';

sealed class AdminReportsEvent extends Equatable {
  const AdminReportsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchAdminReports extends AdminReportsEvent {
  final ReportFilterParams? presetFilter;

  const FetchAdminReports({this.presetFilter});

  @override
  List<Object?> get props => [presetFilter];
}

final class UpdateAdminFilter extends AdminReportsEvent {
  final ReportFilterParams newFilter;

  const UpdateAdminFilter(this.newFilter);

  @override
  List<Object?> get props => [newFilter];
}
