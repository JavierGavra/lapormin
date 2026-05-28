import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_field_officer_reports.dart';

part 'field_officer_reports_event.dart';
part 'field_officer_reports_state.dart';

class FieldOfficerReportsBloc
    extends Bloc<FieldOfficerReportsEvent, FieldOfficerReportsState> {
  final GetFieldOfficerReports _getFieldOfficerReports;

  FieldOfficerReportsBloc({
    required GetFieldOfficerReports getFieldOfficerReports,
  }) : _getFieldOfficerReports = getFieldOfficerReports,
       super(const FieldOfficerReportsState()) {
    on<FetchFieldOfficerReports>(_onFetchFieldOfficerReports);
  }

  Future<void> _onFetchFieldOfficerReports(
    FetchFieldOfficerReports event,
    Emitter<FieldOfficerReportsState> emit,
  ) async {
    emit(state.copyWith(status: FieldOfficerReportsStatus.loading));

    final params = ReportFilterParams(
      category: event.category,
      status: event.status,
      keyword: event.keyword,
    );

    try {
      final result = await _getFieldOfficerReports(params);

      result.fold(
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
          ),
        ),
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
}
