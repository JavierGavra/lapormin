part of 'public_reports_bloc.dart';

abstract class PublicReportsEvent extends Equatable {
  const PublicReportsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPublicReports extends PublicReportsEvent {
  const FetchPublicReports();
}

class UpdatePublicFilter extends PublicReportsEvent {
  final ReportFilterParams newFilter;

  const UpdatePublicFilter(this.newFilter);

  @override
  List<Object?> get props => [newFilter];
}
