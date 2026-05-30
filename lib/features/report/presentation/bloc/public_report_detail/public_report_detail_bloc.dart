import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/report.dart';
import '../../../domain/use_cases/get_report.dart';

part 'public_report_detail_event.dart';
part 'public_report_detail_state.dart';

class PublicReportDetailBloc
    extends Bloc<PublicReportDetailEvent, PublicReportDetailState> {
  final GetReport _getReport;

  PublicReportDetailBloc({required GetReport getReport})
    : _getReport = getReport,
      super(const PublicReportDetailState()) {
    on<PublicReportDetailOpened>(_onLoadPublicReportDetail);
  }

  Future<void> _onLoadPublicReportDetail(
    PublicReportDetailOpened event,
    Emitter<PublicReportDetailState> emit,
  ) async {
    emit(state.copyWith(status: PublicReportDetailStatus.loading));

    final data = await _getReport(GetReportParams(id: event.id));

    data.fold(
      (failure) => emit(
        state.copyWith(
          status: PublicReportDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (report) => emit(
        state.copyWith(
          status: PublicReportDetailStatus.success,
          report: report,
        ),
      ),
    );
  }
}
