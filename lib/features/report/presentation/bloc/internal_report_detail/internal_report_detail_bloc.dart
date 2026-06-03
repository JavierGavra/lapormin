import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/constants/report_status_enum.dart';
import '../../../../../core/error/failures.dart';
import '../../../domain/entities/report.dart';
import '../../../domain/entities/report_aggregate.dart';
import '../../../domain/use_cases/assign_field_officer.dart';
import '../../../domain/use_cases/completing_report.dart';
import '../../../domain/use_cases/get_report_aggregate.dart';
import '../../../domain/use_cases/provide_action.dart';
import '../../../domain/use_cases/reject_report.dart';
import '../../../domain/use_cases/verify_report.dart';

part 'internal_report_detail_event.dart';
part 'internal_report_detail_state.dart';

class InternalReportDetailBloc
    extends Bloc<InternalReportDetailEvent, InternalReportDetailState> {
  final GetReportAggregate _getReportAggregate;
  final AssignFieldOfficer _assignFieldOfficer;
  final VerifyReport _verifyReport;
  final RejectReport _rejectReport;
  final ProvideAction _provideAction;
  final CompletingReport _completingReport;

  InternalReportDetailBloc({
    required GetReportAggregate getReportAggregate,
    required AssignFieldOfficer assignFieldOfficer,
    required VerifyReport verifyReport,
    required RejectReport rejectReport,
    required ProvideAction provideAction,
    required CompletingReport completingReport,
  }) : _getReportAggregate = getReportAggregate,
       _assignFieldOfficer = assignFieldOfficer,
       _verifyReport = verifyReport,
       _rejectReport = rejectReport,
       _provideAction = provideAction,
       _completingReport = completingReport,
       super(InternalReportDetailState()) {
    on<InternalReportDetailOpened>(_onInternalReportDetailOpened);
    on<FieldCheckRequested>(_onFieldCheckRequested);
    on<VerifiedRequested>(_onVerifiedRequested);
    on<RejectedRequested>(_onRejectedRequested);
    on<ActionRequested>(_onActionRequested);
    on<DoneRequested>(_onDoneRequested);
  }

  ReportAggregate? _updateReport(Report report) {
    final currentAggregate = state.reportAggregate;
    if (currentAggregate == null) return null;

    return ReportAggregate(
      report: currentAggregate.report.copyWith(status: report.status),
      fieldCheck: currentAggregate.fieldCheck,
      finalReport: currentAggregate.finalReport,
      statusLogs: currentAggregate.statusLogs,
    );
  }

  Future<void> _callUseCase({
    required Emitter<InternalReportDetailState> emit,
    required Future<Either<Failure, dynamic>> Function() useCase,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final result = await useCase();

    result.fold(
      (failure) => _emitFailure(emit, failure.message!),
      (data) => (data is Report)
          ? emit(
              state.copyWith(
                status: InternalReportDetailStatus.success,
                reportAggregate: _updateReport(data),
              ),
            )
          : add(InternalReportDetailOpened(state.reportAggregate!.report.id)),
    );
  }

  String _getReportId(Emitter<InternalReportDetailState> emit) {
    final id = state.reportAggregate?.report.id;
    if (id == null) {
      emit(state.copyWith(status: InternalReportDetailStatus.failure));
    }
    return id!;
  }

  void _emitFailure(Emitter<InternalReportDetailState> emit, String message) {
    emit(
      state.copyWith(
        status: InternalReportDetailStatus.failure,
        errorMessage: message,
      ),
    );
  }

  Future<void> _onInternalReportDetailOpened(
    InternalReportDetailOpened event,
    Emitter<InternalReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: InternalReportDetailStatus.loading));

    final reportAggregate = await _getReportAggregate(
      GetReportAggregateParams(id: event.id),
    );

    reportAggregate.fold(
      (failure) => _emitFailure(emit, failure.message!),
      (reportAggregate) => emit(
        state.copyWith(
          status: InternalReportDetailStatus.success,
          reportStatus: reportAggregate.report.status,
          reportAggregate: reportAggregate,
        ),
      ),
    );
  }

  Future<void> _onFieldCheckRequested(
    FieldCheckRequested event,
    Emitter<InternalReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: InternalReportDetailStatus.overlayLoading));
    await _callUseCase(
      emit: emit,
      useCase: () => _assignFieldOfficer(
        AssignFieldOfficerParams(
          reportId: _getReportId(emit),
          fieldOfficerId: event.fieldOfficerId,
        ),
      ),
    );
  }

  Future<void> _onVerifiedRequested(
    VerifiedRequested event,
    Emitter<InternalReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: InternalReportDetailStatus.overlayLoading));
    await _callUseCase(
      emit: emit,
      useCase: () => _verifyReport(VerifyReportParams(id: _getReportId(emit))),
    );
  }

  Future<void> _onRejectedRequested(
    RejectedRequested event,
    Emitter<InternalReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: InternalReportDetailStatus.overlayLoading));
    await _callUseCase(
      emit: emit,
      useCase: () => _rejectReport(RejectReportParams(id: _getReportId(emit))),
    );
  }

  Future<void> _onActionRequested(
    ActionRequested event,
    Emitter<InternalReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: InternalReportDetailStatus.overlayLoading));
    await _callUseCase(
      emit: emit,
      useCase: () => _provideAction(
        ProvideActionParams(
          reportId: _getReportId(emit),
          dueAction: event.dueAction,
        ),
      ),
    );
  }

  Future<void> _onDoneRequested(
    DoneRequested event,
    Emitter<InternalReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: InternalReportDetailStatus.overlayLoading));
    await _callUseCase(
      emit: emit,
      useCase: () =>
          _completingReport(CompletingReportParams(id: _getReportId(emit))),
    );
  }
}
