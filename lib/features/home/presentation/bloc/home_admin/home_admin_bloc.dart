import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/entities/report_statistics.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_reports.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_report_statistics.dart';

part 'home_admin_event.dart';
part 'home_admin_state.dart';

class HomeAdminBloc extends Bloc<HomeAdminEvent, HomeAdminState> {
  final GetAdminReports _getAdminReports;
  final GetAdminReportStatistics _getAdminReportStatistics;

  HomeAdminBloc({
    required GetAdminReports getAdminReports,
    required GetAdminReportStatistics getAdminReportStatistics,
  }) : _getAdminReports = getAdminReports,
       _getAdminReportStatistics = getAdminReportStatistics,
       super(const HomeAdminState()) {
    on<FetchHomeAdminReports>(_onFetchHomeAdminReports);
  }

  Future<void> _onFetchHomeAdminReports(
    FetchHomeAdminReports event,
    Emitter<HomeAdminState> emit,
  ) async {
    emit(state.copyWith(status: HomeAdminStatus.loading));

    final statsResult = await _getAdminReportStatistics(NoParams());
    final reportsResult = await _getAdminReports(const ReportFilterParams());

    statsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeAdminStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (stats) {
        reportsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: HomeAdminStatus.failure,
              errorMessage: failure.message,
            ),
          ),
          (reports) => emit(
            state.copyWith(
              status: HomeAdminStatus.success,
              reports: reports,
              statistics: stats,
            ),
          ),
        );
      },
    );
  }
}
