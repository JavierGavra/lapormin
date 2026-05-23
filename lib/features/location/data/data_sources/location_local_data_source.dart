import 'package:geolocator/geolocator.dart';
import 'package:lapormin/core/error/exceptions.dart';
import 'package:latlong2/latlong.dart';

abstract class LocationLocalDataSource {
  Future<LatLng> getCurrentPosition();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<LatLng> getCurrentPosition() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationException('Izin lokasi ditolak.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Izin lokasi diblokir. Aktifkan di pengaturan.',
      );
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException('Layanan GPS tidak aktif.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return LatLng(position.latitude, position.longitude);
  }
}
