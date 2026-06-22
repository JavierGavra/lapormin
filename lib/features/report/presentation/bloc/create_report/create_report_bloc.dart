import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants/report_category_enum.dart';
import '../../../domain/use_cases/submit_report.dart';

part 'create_report_event.dart';
part 'create_report_state.dart';

class CreateReportBloc extends Bloc<CreateReportEvent, CreateReportState> {
  final SubmitReport _submitReport;

  CreateReportBloc({required SubmitReport submitReport})
    : _submitReport = submitReport,
      super(const CreateReportState()) {
    on<CreateReportStep1Submitted>(_onStep1Submitted);
    on<CreateReportStep2Submitted>(_onStep2Submitted);
    on<CreateReportStep3Submitted>(_onStep3Submitted);
    on<CreateReportStep4Submitted>(_onStep4Submitted);
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
    emit(
      state.copyWith(
        status: CreateReportStatus.next,
        currentStep: state.currentStep + 1,
        evidences: event.evidences,
      ),
    );
  }

  Future<void> _onStep4Submitted(
    CreateReportStep4Submitted event,
    Emitter<CreateReportState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CreateReportStatus.loading,
        description: event.description,
      ),
    );

    final isSubmitted = await _submitReport(
      SubmitReportParams(
        title: state.title!,
        description: state.description!,
        latitude: state.position!.latitude,
        longitude: state.position!.longitude,
        category: state.category!,
        address: state.address!,
        evidences: state.evidences,
      ),
    );

    isSubmitted.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateReportStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (success) => emit(state.copyWith(status: CreateReportStatus.success)),
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
}
