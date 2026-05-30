import '../../domain/entities/final_report.dart';

class FinalReportModel extends FinalReport {
  const FinalReportModel({
    required super.id,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.evidences,
  });

  factory FinalReportModel.fromMap(Map<String, dynamic> data) {
    return FinalReportModel(
      id: data['id'],
      description: data['description'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
      evidences: List<String>.from(data['evidences'] ?? []),
    );
  }
}
