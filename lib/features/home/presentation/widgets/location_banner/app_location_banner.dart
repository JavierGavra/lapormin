import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';

class LocationBanner extends StatelessWidget {
  final String location;
  final VoidCallback? onTap;

  const LocationBanner({super.key, required this.location, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Material(
      color: color.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.location_on_rounded, color: color.onPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                location,
                style: AppTextStyle.s14(
                  color: color.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
