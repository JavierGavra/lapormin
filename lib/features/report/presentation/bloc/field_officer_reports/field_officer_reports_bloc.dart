import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    on<UpdateFieldOfficerFilter>(_onUpdateFieldOfficerFilter);
  }

  Future<void> _onFetchFieldOfficerReports(
    FetchFieldOfficerReports event,
    Emitter<FieldOfficerReportsState> emit,
  ) async {
    emit(state.copyWith(status: FieldOfficerReportsStatus.loading));

    try {
      final result = await _getFieldOfficerReports(state.filter);

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

  void _onUpdateFieldOfficerFilter(
    UpdateFieldOfficerFilter event,
    Emitter<FieldOfficerReportsState> emit,
  ) {
    emit(state.copyWith(filter: event.newFilter));
    add(const FetchFieldOfficerReports());
  }
}
