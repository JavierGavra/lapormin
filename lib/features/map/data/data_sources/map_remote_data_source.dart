import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lapormin/core/error/exceptions.dart';

abstract class MapRemoteDataSource {
  Future<List<Map<String, dynamic>>> getNearbyActiveReports(
    double lat,
    double lon,
    double radiusKm,
  );
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  final SupabaseClient supabase;

  MapRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<Map<String, dynamic>>> getNearbyActiveReports(
    double lat,
    double lon,
    double radiusKm,
  ) async {
    try {
      final response = await supabase.rpc(
        'get_nearby_active_reports',
        params: {'user_lat': lat, 'user_lon': lon, 'radius_km': radiusKm},
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw ServerException('Gagal mengambil data peta: $e');
    }
  }
}
