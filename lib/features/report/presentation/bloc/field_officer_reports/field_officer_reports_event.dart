part of 'field_officer_reports_bloc.dart';

sealed class FieldOfficerReportsEvent extends Equatable {
  const FieldOfficerReportsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchFieldOfficerReports extends FieldOfficerReportsEvent {
  final ReportCategory? category;
  final ReportStatus? status;
  final String? keyword;

  const FetchFieldOfficerReports({this.category, this.status, this.keyword});

  @override
  List<Object?> get props => [category, status, keyword];
}
