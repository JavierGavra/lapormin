import 'package:flutter/material.dart';

import '../../../../../../core/utils/text_style/app_text_style.dart';

class EvidencesMediaBottomSheet extends StatelessWidget {
  final VoidCallback onPickPhoto;
  final VoidCallback onPickVideo;

  const EvidencesMediaBottomSheet({
    super.key,
    required this.onPickPhoto,
    required this.onPickVideo,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onPickPhoto,
    required VoidCallback onPickVideo,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => EvidencesMediaBottomSheet(
        onPickPhoto: onPickPhoto,
        onPickVideo: onPickVideo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Jenis Bukti",
              style: AppTextStyle.s16(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              "Hanya dari kamera. Format: PNG, JPG, JPEG, HEIC, MP4, MOV.",
              style: AppTextStyle.s14(color: color.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            _buildOption(
              context,
              icon: Icons.camera_alt_rounded,
              label: "Ambil Foto",
              onTap: () {
                Navigator.pop(context);
                onPickPhoto();
              },
            ),
            const SizedBox(height: 8),
            _buildOption(
              context,
              icon: Icons.videocam_rounded,
              label: "Rekam Video",
              onTap: () {
                Navigator.pop(context);
                onPickVideo();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final color = Theme.of(context).colorScheme;
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.primary),
      ),
      tileColor: Colors.transparent,
      leading: Icon(icon, color: color.primary),
      title: Text(
        label,
        style: AppTextStyle.s14(
          fontWeight: FontWeight.w500,
          color: color.primary,
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 16, right: 12),
      trailing: Icon(Icons.chevron_right_rounded, color: color.primary),
    );
  }
}
