import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/report_category_enum.dart'
    show ReportCategory;
import '../../../location/presentation/bloc/location_picker/location_picker_bloc.dart'
    show
        LocationPickerBloc,
        LocationPickerStarted,
        LocationPickerState,
        LocationPickerStatus;
import '../bloc/map_bloc.dart' hide MapEvent;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<LocationPickerBloc>().add(LocationPickerStarted());
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd && event.source == MapEventSource.dragEnd) {
      final currentCenter = _mapController.camera.center;

      context.read<MapBloc>().add(
        FetchNearbyReports(
          latitude: currentCenter.latitude,
          longitude: currentCenter.longitude,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: const Color(0xFF12202F),
      body: BlocConsumer<LocationPickerBloc, LocationPickerState>(
        listenWhen: (prev, curr) =>
            curr.status == LocationPickerStatus.success &&
            curr.position != null,
        listener: (context, locationState) {
          final pos = locationState.position!;
          context.read<MapBloc>().add(
            FetchNearbyReports(
              latitude: pos.latitude,
              longitude: pos.longitude,
            ),
          );
        },
        builder: (context, locationState) {
          if (locationState.position == null ||
              locationState.isLocationLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: color.onPrimary),
                  const SizedBox(height: 16),
                  Text(
                    'Mencari lokasimu...',
                    style: TextStyle(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final myRealPosition = locationState.position!;

          return BlocBuilder<MapBloc, MapState>(
            builder: (context, mapState) {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: myRealPosition,
                      initialZoom: 16.0,
                      onMapEvent: _onMapEvent,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.unggulan.lapormin',
                      ),
                      MarkerLayer(
                        markers: mapState.reports.map((report) {
                          final categoryEnum = ReportCategory.fromString(
                            report.category,
                          );
                          final pinColor = categoryEnum
                              .getColor(context)
                              .mainColor;

                          return Marker(
                            point: LatLng(report.latitude, report.longitude),
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.location_on,
                              size: 40,
                              color: pinColor,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 24,
                    top: 54,
                    right: 24,
                    child: _buildInfoCard(mapState),
                  ),
                  Positioned(
                    left: 24,
                    bottom: 30,
                    // right: 24,
                    child: _buildLegendCard(context),
                  ),
                  if (mapState.status == MapStatus.loading)
                    const Center(child: CircularProgressIndicator()),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(MapState state) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.onPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.map, color: color.onPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peta Laporan',
                style: TextStyle(
                  color: color.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${state.reports.length} laporan aktif di sekitar anda',
                style: TextStyle(
                  color: color.scrim,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendCard(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          _LegendItem(
            color: ReportCategory.infrastructure.getColor(context).mainColor,
            label: 'Infrastruktur',
          ),
          _LegendItem(
            color: ReportCategory.disaster.getColor(context).mainColor,
            label: 'Bencana',
          ),
          _LegendItem(
            color: ReportCategory.crime.getColor(context).mainColor,
            label: 'Kriminal',
          ),
          _LegendItem(
            color: ReportCategory.publicService.getColor(context).mainColor,
            label: 'Layanan Publik',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyle.s12(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
