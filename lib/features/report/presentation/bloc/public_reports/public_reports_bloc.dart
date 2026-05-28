import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_public_reports.dart';

part 'public_reports_event.dart';
part 'public_reports_state.dart';

class PublicReportsBloc extends Bloc<PublicReportsEvent, PublicReportsState> {
  final GetPublicReports _getPublicReports;

  PublicReportsBloc({required GetPublicReports getPublicReports})
    : _getPublicReports = getPublicReports,
      super(const PublicReportsState()) {
    on<FetchPublicReports>(_onFetchPublicReports);
  }

  Future<void> _onFetchPublicReports(
    FetchPublicReports event,
    Emitter<PublicReportsState> emit,
  ) async {
    emit(state.copyWith(status: PublicReportsStatus.loading));

    final params = ReportFilterParams(
      category: event.category,
      status: event.status,
      keyword: event.keyword,
    );

    final result = await _getPublicReports(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PublicReportsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reports) => emit(
        state.copyWith(status: PublicReportsStatus.success, reports: reports),
      ),
    );
  }
}
