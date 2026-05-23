import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:lapormin/features/location/presentation/widgets/location_picker/gps_button.dart';
import 'package:latlong2/latlong.dart';

class MapCard extends StatefulWidget {
  const MapCard({super.key, this.height = 300});
  final double height;

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  final _mapController = MapController();

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd && event.source == MapEventSource.dragEnd) {
      context.read<LocationPickerBloc>().add(
        LocationPickerAddressRequested(_mapController.camera.center),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocListener<LocationPickerBloc, LocationPickerState>(
      listenWhen: (prev, curr) =>
          prev.isLocationLoading &&
          curr.status == LocationPickerStatus.success &&
          curr.position != null,
      listener: (context, state) {
        _mapController.move(state.position!, 16);
      },
      child: SizedBox(
        height: widget.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: const LatLng(-6.9175, 107.6191),
                  initialZoom: 16,
                  onMapEvent: _onMapEvent,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.unggulan.lapormin',
                  ),
                ],
              ),
              _buildCenterPin(),

              // ── Loading Overlay ─────────────────────────────
              BlocBuilder<LocationPickerBloc, LocationPickerState>(
                buildWhen: (prev, curr) =>
                    prev.isLocationLoading != curr.isLocationLoading,
                builder: (context, state) {
                  if (!state.isLocationLoading) return const SizedBox.shrink();
                  return Container(
                    color: color.surfaceContainer,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),

              // ── GPS Button ──────────────────────────────────
              const Positioned(top: 12, right: 12, child: GpsButton()),
            ],
          ),
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
}
