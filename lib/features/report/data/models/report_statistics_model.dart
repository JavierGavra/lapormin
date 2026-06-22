import '../../domain/entities/report_statistics.dart';

class ReportStatisticsModel extends ReportStatistics {
  const ReportStatisticsModel({
    required super.pending,
    required super.processing,
    required super.done,
    required super.total,
    required super.infrastructure,
    required super.disaster,
    required super.crime,
    required super.publicService,
  });

  factory ReportStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ReportStatisticsModel(
      pending: json['pending'] ?? 0,
      processing: json['processing'] ?? 0,
      done: json['done'] ?? 0,
      total: json['total'] ?? 0,
      infrastructure: json['infrastructure'] ?? 0,
      disaster: json['disaster'] ?? 0,
      crime: json['crime'] ?? 0,
      publicService: json['publicService'] ?? 0,
    );
  }
}
