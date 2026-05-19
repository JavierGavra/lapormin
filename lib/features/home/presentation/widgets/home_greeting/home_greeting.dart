import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';

class HomeGreeting extends StatelessWidget {
  final String userName;
  final String location;

  const HomeGreeting({
    super.key,
    required this.userName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selamat Datang,",
          style: AppTextStyle.s24(
            fontWeight: FontWeight.w700,
            fontFamily: "Plus Jakarta Sans",
          ),
        ),
        const SizedBox(height: 4),

        Text(userName, style: AppTextStyle.s24(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),

        Row(
          children: [
            Icon(Icons.location_on_outlined, color: color.tertiary, size: 16),
            const SizedBox(width: 4),
            Text(
              location,
              style: AppTextStyle.s14(color: color.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}
