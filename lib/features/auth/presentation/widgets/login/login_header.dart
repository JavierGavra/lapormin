import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.primary,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                spreadRadius: -4,
                offset: const Offset(0, 4),
                color: color.shadow.withValues(alpha: 0.1),
              ),
              BoxShadow(
                blurRadius: 15,
                spreadRadius: -3,
                offset: const Offset(0, 10),
                color: color.shadow.withValues(alpha: 0.1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Selamat Datang",
          style: AppTextStyle.s22(
            fontWeight: FontWeight.w700,
            fontFamily: "Plus Jakarta Sans",
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Laportkan hal di sekitar anda pada mimin!",
          style: AppTextStyle.s14(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
