import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import 'package:lapormin/core/error/exceptions.dart';

abstract class LocationRemoteDataSource {
  Future<String> getAddressFromCoordinate(LatLng position);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  @override
  Future<String> getAddressFromCoordinate(LatLng position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      throw const LocationException('Alamat tidak ditemukan');
    }

    final p = placemarks.first;
    final parts = [
      p.subLocality,
      p.locality,
      if (p.subAdministrativeArea != null &&
          p.subAdministrativeArea != p.locality)
        p.subAdministrativeArea,
      p.administrativeArea,
      p.postalCode,
    ].where((e) => e != null && e.isNotEmpty).cast<String>().toList();

    return parts.join(', ');
  }
}
