import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class LocationBanner extends StatelessWidget {
  final String location;
  final bool isSmall;

  const LocationBanner({
    super.key,
    required this.location,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmall ? 16 : 8),
        color: isSmall ? color.secondary : color.primary,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: color.onPrimary,
            size: isSmall ? 16 : 20,
          ),
          Expanded(
            child: Text(
              location,
              style: isSmall
                  ? AppTextStyle.s12(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w500,
                    )
                  : AppTextStyle.s14(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
