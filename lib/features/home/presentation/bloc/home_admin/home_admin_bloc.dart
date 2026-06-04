import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_reports.dart';

part 'home_admin_event.dart';
part 'home_admin_state.dart';

class HomeAdminBloc extends Bloc<HomeAdminEvent, HomeAdminState> {
  final GetAdminReports _getAdminReports;

  HomeAdminBloc({required GetAdminReports getAdminReports})
    : _getAdminReports = getAdminReports,
      super(const HomeAdminState()) {
    on<FetchHomeAdminReports>(_onFetchHomeAdminReports);
  }

  Future<void> _onFetchHomeAdminReports(
    FetchHomeAdminReports event,
    Emitter<HomeAdminState> emit,
  ) async {
    emit(state.copyWith(status: HomeAdminStatus.loading));

    // 📍 Home ambil semua tanpa filter
    final result = await _getAdminReports(const ReportFilterParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeAdminStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reports) => emit(
        state.copyWith(status: HomeAdminStatus.success, reports: reports),
      ),
    );
  }
}
