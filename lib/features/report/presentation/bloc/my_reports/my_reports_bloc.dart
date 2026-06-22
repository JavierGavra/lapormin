import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/use_cases/get_user_reports.dart';

part 'my_reports_event.dart';
part 'my_reports_state.dart';

class MyReportsBloc extends Bloc<MyReportsEvent, MyReportsState> {
  final GetUserReports _getUserReports;

  MyReportsBloc({required GetUserReports getUserReports})
    : _getUserReports = getUserReports,
      super(const MyReportsState()) {
    on<FetchMyReports>(_onFetchMyReports);
  }

  Future<void> _onFetchMyReports(
    FetchMyReports event,
    Emitter<MyReportsState> emit,
  ) async {
    emit(state.copyWith(status: MyReportsStatus.loading));

    final result = await _getUserReports(NoParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MyReportsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reports) => emit(
        state.copyWith(status: MyReportsStatus.success, reports: reports),
      ),
    );
  }
}
