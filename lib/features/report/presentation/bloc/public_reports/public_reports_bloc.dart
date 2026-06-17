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

    final locResult = await _getCurrentLocation(NoParams());
    final userResult = await _getUsername(NoParams());
    final result = await _getPublicReports(state.filter);

    String? locationAddress;
    String? userNameData;

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
    userResult.fold((l) => null, (r) => userNameData = r);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PublicReportsStatus.failure,
          errorMessage: failure.message,
          location: locationAddress,
          username: userNameData,
        ),
      ),
      (reports) => emit(
        state.copyWith(
          status: PublicReportsStatus.success,
          reports: reports,
          location: locationAddress,
          username: userNameData,
        ),
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
