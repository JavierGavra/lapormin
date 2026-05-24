import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ReportInfoMap extends StatelessWidget {
  final LatLng position;

  const ReportInfoMap({super.key, required this.position});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      height: 190,
      decoration: BoxDecoration(
        border: Border.all(color: color.outline),
        borderRadius: BorderRadius.circular(16),
        color: color.surfaceContainerHighest,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: position,
                initialZoom: 16,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.unggulan.lapormin',
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 44,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                Container(
                  width: 12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
