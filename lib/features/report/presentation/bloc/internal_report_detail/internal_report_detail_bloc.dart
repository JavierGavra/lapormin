import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/report/domain/entities/report_aggregate.dart';
import 'package:lapormin/features/report/domain/use_cases/get_report_aggregate.dart';

part 'internal_report_detail_event.dart';
part 'internal_report_detail_state.dart';

class InternalReportDetailBloc
    extends Bloc<InternalReportDetailEvent, InternalReportDetailState> {
  final GetReportAggregate _getReportAggregate;

  InternalReportDetailBloc({required GetReportAggregate getReportAggregate})
    : _getReportAggregate = getReportAggregate,
      super(InternalReportDetailState()) {
    on<InternalReportDetailOpened>(_onInternalReportDetailOpened);
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
      (failure) => emit(
        state.copyWith(
          status: InternalReportDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reportAggregate) => emit(
        state.copyWith(
          status: InternalReportDetailStatus.success,
          reportStatus: reportAggregate.report.status,
          reportAggregate: reportAggregate,
        ),
      ),
    );
  }
}
