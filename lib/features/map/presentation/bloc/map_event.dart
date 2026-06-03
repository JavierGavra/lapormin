part of 'map_bloc.dart';

sealed class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

final class FetchNearbyReports extends MapEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  const FetchNearbyReports({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 5.0, // Default pencarian 5 KM
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusKm];
}
