import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';

class GpsButton extends StatelessWidget {
  const GpsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocBuilder<LocationPickerBloc, LocationPickerState>(
      buildWhen: (prev, curr) =>
          prev.isLocationLoading != curr.isLocationLoading,
      builder: (context, state) {
        return OutlinedButton.icon(
          onPressed: state.isLocationLoading
              ? null
              : () => context.read<LocationPickerBloc>().add(
                  LocationPickerStarted(),
                ),
          icon: Icon(Icons.my_location_rounded, size: 18, color: color.primary),
          label: Text(
            'Posisimu saat ini',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color.primary,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: color.surface,
            padding: const EdgeInsets.only(left: 8, right: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}
