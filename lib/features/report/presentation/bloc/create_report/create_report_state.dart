part of 'create_report_bloc.dart';

sealed class CreateReportState extends Equatable {
  const CreateReportState();
  
  @override
  List<Object> get props => [];
}

final class CreateReportInitial extends CreateReportState {}
