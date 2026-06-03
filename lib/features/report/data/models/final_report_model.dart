import '../../domain/entities/final_report.dart';

class FinalReportModel extends FinalReport {
  const FinalReportModel({
    required super.id,
    required super.description,
    required super.createdAt,
    required super.evidences,
  });

  factory FinalReportModel.fromMap(Map<String, dynamic> data) {
    return FinalReportModel(
      id: data['id'],
      description: data['description'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      evidences: List<String>.from(data['evidences'] ?? []),
    );
  }
}
