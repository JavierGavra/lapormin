import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/use_case/usecase.dart';
import 'package:lapormin/features/location/domain/use_cases/get_address_from_coordinate.dart';
import 'package:lapormin/features/location/domain/use_cases/get_current_location.dart';
import 'package:latlong2/latlong.dart';

part 'location_picker_event.dart';
part 'location_picker_state.dart';

class LocationPickerBloc
    extends Bloc<LocationPickerEvent, LocationPickerState> {
  final GetCurrentLocation _getCurrentLocation;
  final GetAddressFromCoordinate _getAddressFromCoordinate;

  LocationPickerBloc({
    required GetCurrentLocation getCurrentLocation,
    required GetAddressFromCoordinate getAddressFromCoordinate,
  }) : _getCurrentLocation = getCurrentLocation,
       _getAddressFromCoordinate = getAddressFromCoordinate,
       super(const LocationPickerState()) {
    on<LocationPickerStarted>(_onStarted);
    on<LocationPickerAddressRequested>(_onAddressRequested);
  }

  Future<void> _onStarted(
    LocationPickerStarted event,
    Emitter<LocationPickerState> emit,
  ) async {
    emit(state.copyWith(status: LocationPickerStatus.locationLoading));

    final location = await _getCurrentLocation(NoParams());

    location.fold(
      (failure) => emit(
        state.copyWith(
          status: LocationPickerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (location) => emit(
        state.copyWith(
          status: LocationPickerStatus.success,
          position: location.position,
          address: location.address,
        ),
      ),
    );
  }

  Future<void> _onAddressRequested(
    LocationPickerAddressRequested event,
    Emitter<LocationPickerState> emit,
  ) async {
    emit(state.copyWith(status: LocationPickerStatus.addressLoading));

    final address = await _getAddressFromCoordinate(
      GetAddressFromCoordinateParams(position: event.position),
    );

    address.fold(
      (failure) => emit(
        state.copyWith(
          status: LocationPickerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (address) => emit(
        state.copyWith(
          status: LocationPickerStatus.success,
          address: address,
          position: event.position,
        ),
      ),
    );
  }
}
