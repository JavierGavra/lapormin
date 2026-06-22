import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';
import 'package:lapormin/features/location/presentation/widgets/location_picker/address_card.dart';
import 'package:lapormin/injection.dart';
import 'package:latlong2/latlong.dart';
import 'map_card.dart';

class LocationPicker extends StatelessWidget {
  final double mapHeight;
  final void Function(LatLng position, String address)? onLocationChanged;

  const LocationPicker({
    super.key,
    this.mapHeight = 300,
    this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<LocationPickerBloc>()..add(LocationPickerStarted()),
      child: BlocListener<LocationPickerBloc, LocationPickerState>(
        listenWhen: (prev, curr) =>
            curr.status == LocationPickerStatus.success &&
            (prev.position != curr.position || prev.address != curr.address),
        listener: (context, state) {
          if (state.position != null) {
            onLocationChanged?.call(state.position!, state.address);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MapCard(height: mapHeight),
            const SizedBox(height: 16),
            const AddressCard(),
          ],
        ),
      ),
    );
  }
}
