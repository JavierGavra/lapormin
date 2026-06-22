part of 'field_officer_reports_bloc.dart';

sealed class FieldOfficerReportsEvent extends Equatable {
  const FieldOfficerReportsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchFieldOfficerReports extends FieldOfficerReportsEvent {
  const FetchFieldOfficerReports();
}

final class UpdateFieldOfficerFilter extends FieldOfficerReportsEvent {
  final ReportFilterParams newFilter;

  const UpdateFieldOfficerFilter(this.newFilter);

  @override
  List<Object?> get props => [newFilter];
}
