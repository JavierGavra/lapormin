import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/entities/field_officer_statistics.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_field_officer_reports.dart';
import 'package:lapormin/features/report/domain/use_cases/get_field_officer_report_statistics.dart';
import 'package:lapormin/features/location/domain/use_cases/get_current_location.dart';

part 'field_officer_reports_event.dart';
part 'field_officer_reports_state.dart';

class FieldOfficerReportsBloc
    extends Bloc<FieldOfficerReportsEvent, FieldOfficerReportsState> {
  final GetFieldOfficerReports _getFieldOfficerReports;
  final GetFieldOfficerReportStatistics _getFieldOfficerReportStatistics;
  final GetCurrentLocation _getCurrentLocation;

  FieldOfficerReportsBloc({
    required GetFieldOfficerReports getFieldOfficerReports,
    required GetFieldOfficerReportStatistics getFieldOfficerReportStatistics,
    required GetCurrentLocation getCurrentLocation,
  }) : _getFieldOfficerReports = getFieldOfficerReports,
       _getFieldOfficerReportStatistics = getFieldOfficerReportStatistics,
       _getCurrentLocation = getCurrentLocation,
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
      final locResult = await _getCurrentLocation(NoParams());
      final reportsResult = await _getFieldOfficerReports(state.filter);

      String? locationAddress;
      locResult.fold((l) => null, (r) {
        final fullAddress = r.address;
        final parts = fullAddress.split(', ');

        locationAddress = parts.firstWhere(
          (part) =>
              part.toLowerCase().contains('kota') ||
              part.toLowerCase().contains('kabupaten'),
          orElse: () => parts.length > 1 ? parts[1] : parts.first,
        );
      });

      statsResult.fold(
        (failure) => emit(
          state.copyWith(
            status: FieldOfficerReportsStatus.failure,
            errorMessage: failure.message,
            location: locationAddress,
          ),
        ),
        (stats) {
          reportsResult.fold(
            (failure) => emit(
              state.copyWith(
                status: FieldOfficerReportsStatus.failure,
                errorMessage: failure.message,
                location: locationAddress,
              ),
            ),
            (reports) => emit(
              state.copyWith(
                status: FieldOfficerReportsStatus.success,
                reports: reports,
                statistics: stats,
                location: locationAddress,
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
