part of 'public_reports_bloc.dart';

sealed class PublicReportsEvent extends Equatable {
  const PublicReportsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchPublicReports extends PublicReportsEvent {
  final ReportCategory? category;
  final ReportStatus? status;
  final String? keyword;

  const FetchPublicReports({this.category, this.status, this.keyword});

  @override
  List<Object?> get props => [category, status, keyword];
}
