import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.secondary),
      ),
      child: BlocBuilder<LocationPickerBloc, LocationPickerState>(
        buildWhen: (prev, curr) =>
            prev.address != curr.address || prev.status != curr.status,
        builder: (context, state) {
          if (state.isLoading) {
            return Row(
              spacing: 12,
              children: [
                SizedBox(
                  height: 14,
                  width: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                Text(
                  "Mengambil lokasi...",
                  style: AppTextStyle.s14(color: color.secondary),
                ),
              ],
            );
          }

          // Success
          return Text(
            state.status == LocationPickerStatus.failure
                ? state.errorMessage!
                : state.address,
            style: AppTextStyle.s14(color: color.secondary),
          );
        },
      ),
    );
  }
}
