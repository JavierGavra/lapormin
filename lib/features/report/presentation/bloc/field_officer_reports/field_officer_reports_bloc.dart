import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/entities/field_officer_statistics.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_field_officer_reports.dart';
import 'package:lapormin/features/report/domain/use_cases/get_field_officer_report_statistics.dart';

part 'field_officer_reports_event.dart';
part 'field_officer_reports_state.dart';

class FieldOfficerReportsBloc
    extends Bloc<FieldOfficerReportsEvent, FieldOfficerReportsState> {
  final GetFieldOfficerReports _getFieldOfficerReports;
  final GetFieldOfficerReportStatistics _getFieldOfficerReportStatistics;

  FieldOfficerReportsBloc({
    required GetFieldOfficerReports getFieldOfficerReports,
    required GetFieldOfficerReportStatistics getFieldOfficerReportStatistics,
  }) : _getFieldOfficerReports = getFieldOfficerReports,
       _getFieldOfficerReportStatistics = getFieldOfficerReportStatistics,
       super(const FieldOfficerReportsState()) {
    on<FetchFieldOfficerReports>(_onFetchFieldOfficerReports);
    on<UpdateFieldOfficerFilter>(_onUpdateFieldOfficerFilter);
  }

  Future<void> _onFetchFieldOfficerReports(
    FetchFieldOfficerReports event,
    Emitter<FieldOfficerReportsState> emit,
  ) async {
    emit(state.copyWith(status: FieldOfficerReportsStatus.loading));

    try {
      final statsResult = await _getFieldOfficerReportStatistics(NoParams());
      final reportsResult = await _getFieldOfficerReports(state.filter);

      statsResult.fold(
        (failure) => emit(
          state.copyWith(
            status: FieldOfficerReportsStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (stats) {
          reportsResult.fold(
            (failure) => emit(
              state.copyWith(
                status: FieldOfficerReportsStatus.failure,
                errorMessage: failure.message,
              ),
            ),
            (reports) => emit(
              state.copyWith(
                status: FieldOfficerReportsStatus.success,
                reports: reports,
                statistics: stats,
              ),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FieldOfficerReportsStatus.failure,
          errorMessage: "Terjadi kesalahan sistem: ${e.toString()}",
        ),
      );
    }
  }

  void _onUpdateFieldOfficerFilter(
    UpdateFieldOfficerFilter event,
    Emitter<FieldOfficerReportsState> emit,
  ) {
    emit(state.copyWith(filter: event.newFilter));
    add(const FetchFieldOfficerReports());
  }
}
