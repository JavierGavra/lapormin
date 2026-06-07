import '../../domain/entities/field_officer.dart';

class FieldOfficerModel extends FieldOfficer {
  const FieldOfficerModel({
    required super.id,
    required super.name,
    required super.phone,
  });

  // 📍 Menerjemahkan JSON dari Supabase (username & no_telp) ke Object Flutter
  factory FieldOfficerModel.fromJson(Map<String, dynamic> json) {
    return FieldOfficerModel(
      id: json['id']?.toString() ?? '',
      name:
          json['username'] as String? ??
          'Tanpa Nama', // 👈 Disesuaikan dengan DB
      phone: json['no_telp'] as String? ?? '-', // 👈 Disesuaikan dengan DB
    );
  }

  // 📍 Mengubah Object Flutter menjadi JSON untuk dilempar ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': name, // 👈 Dikembalikan ke nama kolom DB
      'no_telp': phone, // 👈 Dikembalikan ke nama kolom DB
      'role': 'field_officer', // Selalu set role saat nambah petugas
    };
  }
}
