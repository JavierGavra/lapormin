part of 'map_bloc.dart';

enum MapStatus { initial, loading, success, failure }

final class MapState extends Equatable {
  final MapStatus status;
  final List<MapReport> reports;
  final String? errorMessage;

  const MapState({
    this.status = MapStatus.initial,
    this.reports = const [],
    this.errorMessage,
  });

  MapState copyWith({
    MapStatus? status,
    List<MapReport>? reports,
    String? errorMessage,
  }) {
    return MapState(
      status: status ?? this.status,
      reports: reports ?? this.reports,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reports, errorMessage];
}
