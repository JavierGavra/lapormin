import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/report.dart';
import 'package:lapormin/features/report/domain/use_cases/get_report.dart';

part 'public_detail_report_event.dart';
part 'public_detail_report_state.dart';

class PublicDetailReportBloc
    extends Bloc<PublicDetailReportEvent, PublicDetailReportState> {
  final GetReport _getReport;

  PublicDetailReportBloc({required GetReport getReport})
    : _getReport = getReport,
      super(const PublicDetailReportState()) {
    on<LoadPublicDetailReport>(_onLoadPublicDetailReport);
  }

  Future<void> _onLoadPublicDetailReport(
    LoadPublicDetailReport event,
    Emitter<PublicDetailReportState> emit,
  ) async {
    emit(state.copyWith(status: PublicDetailReportStatus.loading));
    try {
      final data = await _getReport(GetReportParams(id: event.id));

      data.fold(
        (failure) => emit(
          state.copyWith(
            status: PublicDetailReportStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (report) => emit(
          state.copyWith(
            status: PublicDetailReportStatus.success,
            report: report,
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: PublicDetailReportStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }
}
