import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:path/path.dart' as path;

import '../../../../../../core/constants/constant.dart';

class EvidencesPreviewItem extends StatelessWidget {
  final String filePath;
  final double size;
  final VoidCallback onRemove;

  const EvidencesPreviewItem({
    super.key,
    required this.filePath,
    required this.size,
    required this.onRemove,
  });

  bool get _isVideo {
    final ext = path.extension(filePath).replaceFirst('.', '').toLowerCase();
    return Constant.evidenceVideoExtensions.contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Thumbnail
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _isVideo
                  ? _buildVideoThumbnail(color)
                  : Image.file(
                      File(filePath),
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                            if (wasSynchronouslyLoaded || frame != null) {
                              return child;
                            }
                            return ShimmerWidget();
                          },
                    ),
            ),
          ),

          // Badge video
          if (_isVideo)
            Positioned(
              bottom: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.scrim.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),

          // Tombol hapus
          Positioned(
            top: -8,
            right: -8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: color.tertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoThumbnail(ColorScheme color) {
    return Container(
      color: color.primaryContainer,
      child: Icon(Icons.videocam_rounded, color: color.primary, size: 32),
    );
  }
}
