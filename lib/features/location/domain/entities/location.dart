import 'package:latlong2/latlong.dart';

class Location {
  final LatLng position;
  final String address;

  const Location({required this.position, required this.address});
}
