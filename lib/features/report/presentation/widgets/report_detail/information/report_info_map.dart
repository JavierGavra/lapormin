import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:latlong2/latlong.dart';

class ReportInfoMap extends StatelessWidget {
  final LatLng position;
  final bool withTitle;

  const ReportInfoMap({
    super.key,
    required this.position,
    this.withTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        if (withTitle) _buildTitle(),
        Container(
          height: 190,
          decoration: BoxDecoration(
            border: Border.all(
              color: withTitle ? color.outlineVariant : color.outline,
            ),
            borderRadius: BorderRadius.circular(16),
            color: color.surfaceContainerHighest,
          ),
          child: Stack(children: [_buildMap(), _buildCenterPin()]),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      "Lokasi di Peta",
      style: AppTextStyle.s16(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildMap() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: position,
          initialZoom: 16,
          interactionOptions: InteractionOptions(flags: InteractiveFlag.none),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.unggulan.lapormin',
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPin() {
    return Center(
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
    );
  }
}
