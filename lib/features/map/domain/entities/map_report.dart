import 'package:equatable/equatable.dart';

class MapReport extends Equatable {
  final String id;
  final String category;
  final double latitude;
  final double longitude;

  const MapReport({
    required this.id,
    required this.category,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [id, category, latitude, longitude];
}
