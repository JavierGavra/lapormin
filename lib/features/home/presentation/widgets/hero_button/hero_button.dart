import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class HeroButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const HeroButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 0),
            spreadRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 26),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Teks & Ikon di tengah
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: color.primary, size: 18),
                  ),
                ),
                const SizedBox(width: 12),

                Text(
                  label,
                  style: AppTextStyle.s16(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
