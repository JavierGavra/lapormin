import '../../domain/entities/field_officer.dart';

class FieldOfficerModel extends FieldOfficer {
  const FieldOfficerModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.reportAmount,
    required super.createdAt,
    required super.imageUrl,
  });

  factory FieldOfficerModel.fromJson(Map<String, dynamic> json) {
    return FieldOfficerModel(
      id: json['id']?.toString() ?? '',
      name: json['username'] as String? ?? 'Tanpa Nama',
      phone: json['no_telp'] as String? ?? '-',
      reportAmount: json['report_amount'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      imageUrl: json['photo_profile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name,
      'no_telp': phone,
      'report_amount': reportAmount,
      'created_at': createdAt.toIso8601String(),
      'role': 'field_officer',
    };
  }
}
