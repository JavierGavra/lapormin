import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/field_officer_model.dart';

abstract class FieldOfficerRemoteDataSource {
  Future<List<FieldOfficerModel>> getFieldOfficers();
  Future<void> addFieldOfficer(String name, String phone, String password);
}

class FieldOfficerRemoteDataSourceImpl implements FieldOfficerRemoteDataSource {
  final SupabaseClient supabase;

  FieldOfficerRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<FieldOfficerModel>> getFieldOfficers() async {
    try {
      final response = await supabase
          .from('users')
          .select('*, field_check(count)')
          .eq('role', 'field_officer')
          .order('created_at', ascending: false);

      return response.map((data) {
        final Map<String, dynamic> rawData = Map<String, dynamic>.from(data);
        int totalFieldChecks = 0;

        if (rawData['field_check'] != null &&
            (rawData['field_check'] as List).isNotEmpty) {
          totalFieldChecks = rawData['field_check'][0]['count'] ?? 0;
        }

        final photoPath = rawData['photo_profile'];
        String? finalImageUrl;

        if (photoPath != null && photoPath.toString().isNotEmpty) {
          finalImageUrl = supabase.storage
              .from('avatars')
              .getPublicUrl(photoPath);
        }

        rawData['report_amount'] = totalFieldChecks;

        rawData['photo_profile'] = finalImageUrl;

        rawData.remove('field_check');

        return FieldOfficerModel.fromJson(rawData);
      }).toList();
    } catch (e) {
      throw Exception('Gagal menarik data petugas lapangan: $e');
    }
  }

  @override
  Future<void> addFieldOfficer(
    String name,
    String phone,
    String password,
  ) async {
    try {
      final response = await supabase.functions.invoke(
        'create_field_officer',
        body: {'name': name, 'phone': phone, 'password': password},
      );

      if (response.status != 200) {
        throw Exception('Gagal mendaftarkan petugas dari server.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
