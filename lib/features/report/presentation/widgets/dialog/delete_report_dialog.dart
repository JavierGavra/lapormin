import 'package:flutter/material.dart';

import '../../../../../core/utils/text_style/app_text_style.dart';

class DeleteReportDialog extends StatelessWidget {
  const DeleteReportDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const DeleteReportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    String title = 'Hapus Laporan';
    String message = 'Anda yakin ingin menghapus laporan ini?';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyle.s20(
                color: color.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyle.s14(color: color.onSurfaceVariant),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 40),
                      textStyle: AppTextStyle.s14(color: color.primary),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: color.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(double.infinity, 40),
                      textStyle: AppTextStyle.s14(color: color.onError),
                    ),
                    child: const Text('Hapus'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
