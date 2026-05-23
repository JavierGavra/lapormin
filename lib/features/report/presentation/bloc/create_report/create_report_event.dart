part of 'create_report_bloc.dart';

sealed class CreateReportEvent extends Equatable {
  const CreateReportEvent();

  @override
  List<Object?> get props => [];
}

final class CreateReportStep1Submitted extends CreateReportEvent {
  final String title;
  final ReportCategory category;

  const CreateReportStep1Submitted({
    required this.title,
    required this.category,
  });

  @override
  List<Object?> get props => [title, category];
}

final class CreateReportStep2Submitted extends CreateReportEvent {
  final LatLng position;
  final String address;

  const CreateReportStep2Submitted({
    required this.position,
    required this.address,
  });

  @override
  List<Object?> get props => [position, address];
}

final class CreateReportStep3Submitted extends CreateReportEvent {
  final List<String> evidences;

  const CreateReportStep3Submitted({required this.evidences});

  @override
  List<Object?> get props => [evidences];
}

final class CreateReportPreviousStep extends CreateReportEvent {}
