// core/network/widgets/no_connection_page.dart
import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class CrashPage extends StatelessWidget {
  const CrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: color.error),
            const SizedBox(height: 16),
            Text(
              'Tidak Ada Koneksi Internet',
              style: AppTextStyle.s16(
                fontWeight: FontWeight.w600,
                // color: color.onBackground,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(onPressed: () {}, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
