import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/utils/video/video_compressor_utils.dart';
import 'package:lapormin/core/widgets/image/image_viewer_page.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:lapormin/core/widgets/video/video_player_page.dart';
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
    print('🔹 Building EvidencesPreviewItem for: $filePath');
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
                  ? _buildVideoThumbnail(context)
                  : _buildImageThumbnail(context),
            ),
          ),

          // Badge video
          if (_isVideo)
            Positioned(
              bottom: 6,
              left: 6,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
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

  Widget _buildImageThumbnail(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigate.push(
          context,
          ImageViewerPage.file(
            tag: filePath,
            title: "Pratinjau Bukti",
            file: File(filePath),
          ),
        );
      },
      child: Hero(
        tag: filePath,
        child: Image.file(
          File(filePath),
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return const ShimmerWidget();
          },
        ),
      ),
    );
  }

  Widget _buildVideoThumbnail(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigate.push(
          context,
          VideoPlayerPage.file(
            tag: filePath,
            title: "Pratinjau Bukti",
            file: File(filePath),
          ),
        );
      },
      child: Hero(
        tag: filePath,
        child: FutureBuilder<File?>(
          key: ValueKey(filePath),
          future: VideoCompressorUtils.generateThumbnail(filePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.file(snapshot.data!, fit: BoxFit.cover);
            }

            return Container(
              color: color.primaryContainer,
              child: snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.primary,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.videocam_rounded,
                      color: color.primary,
                      size: 32,
                    ),
            );
          },
        ),
      ),
    );
  }
}
