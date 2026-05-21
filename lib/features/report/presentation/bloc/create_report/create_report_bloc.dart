import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_report_event.dart';
part 'create_report_state.dart';

class CreateReportBloc extends Bloc<CreateReportEvent, CreateReportState> {
  CreateReportBloc() : super(CreateReportInitial()) {
    on<CreateReportEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
