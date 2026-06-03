import '../../domain/entities/map_report.dart';

class MapReportModel extends MapReport {
  const MapReportModel({
    required super.id,
    required super.category,
    required super.latitude,
    required super.longitude,
  });

  factory MapReportModel.fromMap(Map<String, dynamic> map) {
    return MapReportModel(
      id: map['id'] as String,
      category: map['category'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
    );
  }
}
