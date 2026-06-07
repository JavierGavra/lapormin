import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/phone_number/phone_number_format.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class FieldOfficerCard extends StatelessWidget {
  final String initial;
  final String name;
  final String phone;
  final VoidCallback onTap;

  const FieldOfficerCard({
    super.key,
    required this.initial,
    required this.name,
    required this.phone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: AppTextStyle.s16(
                  color: color.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyle.s14(
                      color: color.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    PhoneNumberFormat.formatted(phone),
                    style: AppTextStyle.s12(
                      color: color.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded, color: color.onSurface),
          ],
        ),
      ),
    );
  }
}
