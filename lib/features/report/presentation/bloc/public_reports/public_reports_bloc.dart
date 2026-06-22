import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/report/domain/entities/report_summary.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';
import 'package:lapormin/features/report/domain/use_cases/get_public_reports.dart';
import 'package:lapormin/features/location/domain/use_cases/get_current_location.dart';
import 'package:lapormin/features/profile/domain/use_cases/get_username.dart';

part 'public_reports_event.dart';
part 'public_reports_state.dart';

class PublicReportsBloc extends Bloc<PublicReportsEvent, PublicReportsState> {
  final GetPublicReports _getPublicReports;
  final GetCurrentLocation _getCurrentLocation;
  final GetUsername _getUsername;

  PublicReportsBloc({
    required GetPublicReports getPublicReports,
    required GetCurrentLocation getCurrentLocation,
    required GetUsername getUsername,
  }) : _getPublicReports = getPublicReports,
       _getCurrentLocation = getCurrentLocation,
       _getUsername = getUsername,
       super(const PublicReportsState()) {
    on<FetchPublicReports>(_onFetchPublicReports);
    on<UpdatePublicFilter>(_onUpdatePublicFilter);
  }

  Future<void> _onFetchPublicReports(
    FetchPublicReports event,
    Emitter<PublicReportsState> emit,
  ) async {
    emit(state.copyWith(status: PublicReportsStatus.loading));

    final userResult = await _getUsername(NoParams());
    String? userNameData;
    userResult.fold((l) => null, (r) => userNameData = r);

    emit(state.copyWith(username: userNameData));

    final locResult = await _getCurrentLocation(NoParams());
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

    emit(state.copyWith(location: locationAddress));

    final result = await _getPublicReports(state.filter);

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

  void _onUpdatePublicFilter(
    UpdatePublicFilter event,
    Emitter<PublicReportsState> emit,
  ) {
    emit(state.copyWith(filter: event.newFilter));
    add(const FetchPublicReports());
  }
}
