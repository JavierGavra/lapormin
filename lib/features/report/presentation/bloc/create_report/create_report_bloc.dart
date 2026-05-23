import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:latlong2/latlong.dart';

part 'create_report_event.dart';
part 'create_report_state.dart';

class CreateReportBloc extends Bloc<CreateReportEvent, CreateReportState> {
  CreateReportBloc() : super(const CreateReportState()) {
    on<CreateReportStep1Submitted>(_onStep1Submitted);
    on<CreateReportStep2Submitted>(_onStep2Submitted);
    on<CreateReportStep3Submitted>(_onStep3Submitted);
    on<CreateReportPreviousStep>(_onPreviousStep);
  }

  Future<void> _onStep1Submitted(
    CreateReportStep1Submitted event,
    Emitter<CreateReportState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CreateReportStatus.next,
        currentStep: state.currentStep + 1,
        title: event.title,
        category: event.category,
      ),
    );
  }

  Future<void> _onPreviousStep(
    CreateReportPreviousStep event,
    Emitter<CreateReportState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CreateReportStatus.previous,
        currentStep: state.currentStep - 1,
      ),
    );
  }

  Future<void> _onStep2Submitted(
    CreateReportStep2Submitted event,
    Emitter<CreateReportState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CreateReportStatus.next,
        currentStep: state.currentStep + 1,
        position: event.position,
        address: event.address,
      ),
    );
  }

  Future<void> _onStep3Submitted(
    CreateReportStep3Submitted event,
    Emitter<CreateReportState> emit,
  ) async {
    // emit(
    //   state.copyWith(
    //     status: CreateReportStatus.next,
    //     currentStep: state.currentStep + 1,
    //     evidences: event.evidences,
    //   ),
    // );
  }
}
