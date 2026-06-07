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
          .select()
          .eq('role', 'field_officer')
          .order('created_at', ascending: false);

      return response.map((e) => FieldOfficerModel.fromJson(e)).toList();
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
