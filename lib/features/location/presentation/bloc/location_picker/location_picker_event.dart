part of 'location_picker_bloc.dart';

sealed class LocationPickerEvent extends Equatable {
  const LocationPickerEvent();

  @override
  List<Object?> get props => [];
}

final class LocationPickerStarted extends LocationPickerEvent {}

final class LocationPickerAddressRequested extends LocationPickerEvent {
  final LatLng position;

  const LocationPickerAddressRequested(this.position);

  @override
  List<Object?> get props => [position];
}
