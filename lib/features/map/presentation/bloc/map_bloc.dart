import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/map_report.dart';
import '../../domain/use_cases/get_nearby_active_reports.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetNearbyActiveReports _getNearbyActiveReports;

  MapBloc({required GetNearbyActiveReports getNearbyActiveReports})
    : _getNearbyActiveReports = getNearbyActiveReports,
      super(const MapState()) {
    on<FetchNearbyReports>(_onFetchNearbyReports);
  }

  Future<void> _onFetchNearbyReports(
    FetchNearbyReports event,
    Emitter<MapState> emit,
  ) async {
    emit(state.copyWith(status: MapStatus.loading));

    final result = await _getNearbyActiveReports(
      GetNearbyActiveReportsParams(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MapStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (reports) =>
          emit(state.copyWith(status: MapStatus.success, reports: reports)),
    );
  }
}
