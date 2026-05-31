import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportInfoMap extends StatelessWidget {
  final LatLng position;
  final bool withTitle;

  const ReportInfoMap({
    super.key,
    required this.position,
    this.withTitle = false,
  });

  // Buka Google Maps sesuai koordinat
  Future<void> _openGoogleMaps(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showSnackBar(
          context,
          "Tidak bisa membuka Google Maps",
          type: SnackBarType.failure,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        if (withTitle) _buildTitle(),
        GestureDetector(
          onTap: () => _openGoogleMaps(context),
          child: Container(
            height: 190,
            decoration: BoxDecoration(
              border: Border.all(
                color: withTitle ? color.outlineVariant : color.outline,
              ),
              borderRadius: BorderRadius.circular(16),
              color: color.surfaceContainerHighest,
            ),
            child: Stack(
              children: [
                _buildMap(),
                _buildCenterPin(),
                _buildOpenMapsHint(color),
              ],
            ),
          ),
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
      child: AbsorbPointer(
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

  // Hint di pojok kanan bawah agar user tahu peta bisa diklik
  Widget _buildOpenMapsHint(ColorScheme color) {
    return Positioned(
      bottom: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Icon(Icons.open_in_new_rounded, size: 12, color: color.primary),
            Text(
              "Buka di Maps",
              style: AppTextStyle.s11(
                fontWeight: FontWeight.w600,
                color: color.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
