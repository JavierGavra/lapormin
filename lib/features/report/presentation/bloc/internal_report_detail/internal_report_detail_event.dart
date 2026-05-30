part of 'internal_report_detail_bloc.dart';

sealed class InternalReportDetailEvent extends Equatable {
  const InternalReportDetailEvent();

  @override
  List<Object> get props => [];
}

final class InternalReportDetailOpened extends InternalReportDetailEvent {
  final String id;

  const InternalReportDetailOpened(this.id);

  @override
  List<Object> get props => [id];
}
