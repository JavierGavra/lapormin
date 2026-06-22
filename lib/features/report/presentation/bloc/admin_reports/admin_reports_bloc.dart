import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_admin_reports.dart';

part 'admin_reports_event.dart';
part 'admin_reports_state.dart';

class AdminReportsBloc extends Bloc<AdminReportsEvent, AdminReportsState> {
  final GetAdminReports _getAdminReports;

  AdminReportsBloc({required GetAdminReports getAdminReports})
    : _getAdminReports = getAdminReports,
      super(const AdminReportsState()) {
    on<FetchAdminReports>(_onFetchAdminReports);
    on<UpdateAdminFilter>(_onUpdateAdminFilter);
  }

  Future<void> _onFetchAdminReports(
    FetchAdminReports event,
    Emitter<AdminReportsState> emit,
  ) async {
    emit(state.copyWith(status: AdminReportsStatus.loading));

    final activeFilter = event.presetFilter ?? state.filter;

    if (event.presetFilter != null) {
      emit(state.copyWith(filter: activeFilter));
    }

    final result = await _getAdminReports(activeFilter);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminReportsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reports) => emit(
        state.copyWith(status: AdminReportsStatus.success, reports: reports),
      ),
    );
  }

  void _onUpdateAdminFilter(
    UpdateAdminFilter event,
    Emitter<AdminReportsState> emit,
  ) {
    emit(state.copyWith(filter: event.newFilter));
    add(const FetchAdminReports());
  }
}
