import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../location/presentation/widgets/location_picker/location_picker.dart';

class LocationStep extends StatelessWidget {
  const LocationStep({super.key, required this.onLocationChanged});

  final void Function(LatLng position, String address) onLocationChanged;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Dimana laporan berasal?",
            style: AppTextStyle.s24(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Posisikan pin merah ke titik TKP.",
            style: AppTextStyle.s14(color: color.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              return LocationPicker(
                mapHeight: constraints.maxWidth,
                onLocationChanged: onLocationChanged,
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
