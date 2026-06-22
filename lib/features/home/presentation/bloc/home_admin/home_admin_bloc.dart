import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/entities/report_statistics.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_reports.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_report_statistics.dart';
import 'package:lapormin/features/location/domain/use_cases/get_current_location.dart';

part 'home_admin_event.dart';
part 'home_admin_state.dart';

class HomeAdminBloc extends Bloc<HomeAdminEvent, HomeAdminState> {
  final GetAdminReports _getAdminReports;
  final GetAdminReportStatistics _getAdminReportStatistics;
  final GetCurrentLocation _getCurrentLocation;

  HomeAdminBloc({
    required GetAdminReports getAdminReports,
    required GetAdminReportStatistics getAdminReportStatistics,
    required GetCurrentLocation getCurrentLocation,
  }) : _getAdminReports = getAdminReports,
       _getAdminReportStatistics = getAdminReportStatistics,
       _getCurrentLocation = getCurrentLocation,
       super(const HomeAdminState()) {
    on<FetchHomeAdminReports>(_onFetchHomeAdminReports);
  }

  Future<void> _onFetchHomeAdminReports(
    FetchHomeAdminReports event,
    Emitter<HomeAdminState> emit,
  ) async {
    emit(state.copyWith(status: HomeAdminStatus.loading));

    final statsResult = await _getAdminReportStatistics(NoParams());
    final locResult = await _getCurrentLocation(NoParams());
    final reportsResult = await _getAdminReports(const ReportFilterParams());

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
          status: HomeAdminStatus.failure,
          errorMessage: failure.message,
          location: locationAddress,
        ),
      ),
      (stats) {
        reportsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: HomeAdminStatus.failure,
              errorMessage: failure.message,
              location: locationAddress,
            ),
          ),
          (reports) => emit(
            state.copyWith(
              status: HomeAdminStatus.success,
              reports: reports,
              statistics: stats,
              location: locationAddress,
            ),
          ),
        );
      },
    );
  }
}
