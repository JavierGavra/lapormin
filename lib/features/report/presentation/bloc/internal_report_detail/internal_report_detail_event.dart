part of 'internal_report_detail_bloc.dart';

sealed class InternalReportDetailEvent extends Equatable {
  const InternalReportDetailEvent();

  @override
  List<Object?> get props => [];
}

final class InternalReportDetailOpened extends InternalReportDetailEvent {
  final String id;

  const InternalReportDetailOpened(this.id);

  @override
  List<Object?> get props => [id];
}

final class ReportDeleteRequested extends InternalReportDetailEvent {}

final class FieldCheckRequested extends InternalReportDetailEvent {
  final String fieldOfficerId;

  const FieldCheckRequested({required this.fieldOfficerId});

  @override
  List<Object?> get props => [fieldOfficerId];
}

final class VerifiedRequested extends InternalReportDetailEvent {}

final class RejectedRequested extends InternalReportDetailEvent {}

final class ActionRequested extends InternalReportDetailEvent {
  final DateTime? dueAction;

  const ActionRequested({this.dueAction});

  @override
  List<Object?> get props => [dueAction];
}

final class DoneRequested extends InternalReportDetailEvent {}
