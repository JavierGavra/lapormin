import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import '../../utils/text_style/app_text_style.dart';
import '../snackbar/custom_snackbar.dart';

class ImageViewerPage extends StatefulWidget {
  final String tag;
  final String title;
  final String? urlImage;
  final File? file;
  final bool withDownload;
  final Function()? onEdit;

  const ImageViewerPage.network({
    super.key,
    required this.tag,
    required this.title,
    required this.urlImage,
    this.withDownload = false,
    this.onEdit,
  }) : file = null;

  const ImageViewerPage.file({
    super.key,
    required this.tag,
    required this.title,
    required this.file,
    this.withDownload = false,
    this.onEdit,
  }) : urlImage = null;

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage>
    with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  final _isDownloading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() => controller.value = animation!.value);
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    _isDownloading.dispose();

    super.dispose();
  }

  Future<void> _downloadImage(BuildContext context) async {
    _isDownloading.value = true;

    if (widget.urlImage == null) {
      showSnackBar(
        context,
        'Tidak ada gambar untuk diunduh.',
        type: SnackBarType.failure,
      );
      _isDownloading.value = false;
      return;
    }

    try {
      final response = await http.get(Uri.parse(widget.urlImage!));

      if (response.statusCode != 200) throw Exception('Gagal mengunduh gambar');

      final result = await ImageGallerySaverPlus.saveImage(
        response.bodyBytes,
        quality: 100,
        name: "LaporMin_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (context.mounted) {
        final isSuccess = result['isSuccess'] == true;
        showSnackBar(
          context,
          isSuccess
              ? 'Gambar berhasil disimpan ke Galeri!'
              : 'Gagal menyimpan gambar.',
          type: isSuccess ? SnackBarType.success : SnackBarType.failure,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          'Terjadi kesalahan saat mengunduh: $e',
          type: SnackBarType.failure,
        );
      }
    } finally {
      if (mounted) _isDownloading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: color.scrim,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: color.scrim,
        foregroundColor: color.surface,
        actions: [
          if (widget.withDownload)
            ValueListenableBuilder(
              valueListenable: _isDownloading,
              builder: (_, value, _) {
                return IconButton(
                  onPressed: value ? null : () => _downloadImage(context),
                  icon: value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: color.surface,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.download),
                  tooltip: 'Simpan ke Galeri',
                );
              },
            ),

          if (widget.onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: widget.onEdit,
              tooltip: 'Edit Gambar',
            ),
        ],
      ),
      body: (widget.urlImage == null && widget.file == null)
          ? SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: Center(
                child: Text(
                  'Tidak ada gambar',
                  style: AppTextStyle.s14(color: color.surface),
                ),
              ),
            )
          : SizedBox(
              width: double.maxFinite,
              height: double.maxFinite,
              child: GestureDetector(
                onDoubleTapDown: (details) => tapDownDetails = details,
                onDoubleTap: () {
                  final position = tapDownDetails!.localPosition;
                  const double scale = 3;
                  final x = -position.dx * (scale - 1);
                  final y = -position.dy * (scale - 1);
                  final zoomed = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);

                  final value = controller.value.isIdentity()
                      ? zoomed
                      : Matrix4.identity();

                  animation = Matrix4Tween(begin: controller.value, end: value)
                      .animate(
                        CurveTween(
                          curve: Curves.easeOut,
                        ).animate(animationController),
                      );

                  animationController.forward(from: 0);
                },
                child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  transformationController: controller,
                  child: Hero(
                    tag: widget.tag,
                    child: widget.file != null
                        ? Image.file(widget.file!, fit: BoxFit.fitWidth)
                        : Image.network(
                            widget.urlImage!,
                            fit: BoxFit.fitWidth,
                            frameBuilder:
                                (
                                  context,
                                  child,
                                  frame,
                                  wasSynchronouslyLoaded,
                                ) {
                                  if (wasSynchronouslyLoaded || frame != null) {
                                    return child;
                                  }
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: color.surfaceContainerHighest,
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  color: color.onSurfaceVariant,
                                  size: 48,
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ),
    );
  }
}
