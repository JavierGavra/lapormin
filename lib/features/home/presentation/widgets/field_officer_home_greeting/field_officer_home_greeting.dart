import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/utils/time/time_utils.dart';

class FieldOfficerHomeGreeting extends StatelessWidget {
  const FieldOfficerHomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    final greetingTime = TimeUtils.currentDaylight;
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selamat $greetingTime, Pahlawan",
          style: AppTextStyle.s24(
            fontWeight: FontWeight.w700,
            fontFamily: "Plus Jakarta Sans",
            color: color.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Kota sedang menunggu aksimu",
          style: AppTextStyle.s16(
            fontWeight: FontWeight.w400,
            fontFamily: "DM Sans",
            color: color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
