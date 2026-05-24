part of 'public_detail_report_bloc.dart';

sealed class PublicDetailReportEvent extends Equatable {
  const PublicDetailReportEvent();
}

final class LoadPublicDetailReport extends PublicDetailReportEvent {
  final String id;

  const LoadPublicDetailReport(this.id);

  @override
  List<Object> get props => [id];
}
