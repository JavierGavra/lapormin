part of 'public_report_detail_bloc.dart';

sealed class PublicReportDetailEvent extends Equatable {
  const PublicReportDetailEvent();
}

final class PublicReportDetailOpened extends PublicReportDetailEvent {
  final String id;

  const PublicReportDetailOpened(this.id);

  @override
  List<Object> get props => [id];
}
