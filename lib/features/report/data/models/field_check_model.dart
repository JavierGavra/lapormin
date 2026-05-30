import '../../domain/entities/field_check.dart';

class FieldCheckModel extends FieldCheck {
  const FieldCheckModel({
    required super.id,
    required super.fieldOfficerName,
    required super.fieldOfficerPhone,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.evidences,
  });

  factory FieldCheckModel.fromMap(Map<String, dynamic> data) {
    return FieldCheckModel(
      id: data['id'] as String,
      fieldOfficerName: data['field_officer_name'] as String,
      fieldOfficerPhone: data['field_officer_phone'] as String,
      description: data['description'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
      evidences: List<String>.from(data['evidences'] ?? []),
    );
  }
}
