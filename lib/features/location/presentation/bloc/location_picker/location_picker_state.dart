part of 'location_picker_bloc.dart';

enum LocationPickerStatus {
  initial,
  locationLoading,
  addressLoading,
  success,
  failure,
}

final class LocationPickerState extends Equatable {
  final LocationPickerStatus status;
  final LatLng? position;
  final String address;
  final String? errorMessage;

  const LocationPickerState({
    this.status = LocationPickerStatus.initial,
    this.position,
    this.address = 'Mengambil lokasi...',
    this.errorMessage,
  });

  bool get isLocationLoading => status == LocationPickerStatus.locationLoading;
  bool get isAddressLoading => status == LocationPickerStatus.addressLoading;
  bool get isLoading => isLocationLoading || isAddressLoading;

  LocationPickerState copyWith({
    LocationPickerStatus? status,
    LatLng? position,
    String? address,
    String? errorMessage,
  }) {
    return LocationPickerState(
      status: status ?? this.status,
      position: position ?? this.position,
      address: address ?? this.address,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, position, address, errorMessage];
}
