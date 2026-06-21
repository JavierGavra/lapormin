import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../utils/text_style/app_text_style.dart';
import '../snackbar/custom_snackbar.dart';

class VideoPlayerPage extends StatefulWidget {
  final String tag;
  final String title;
  final String? urlVideo;
  final File? file;
  final bool withDownload;

  const VideoPlayerPage.network({
    super.key,
    required this.tag,
    required this.title,
    required this.urlVideo,
    this.withDownload = false,
  }) : file = null;

  const VideoPlayerPage.file({
    super.key,
    required this.tag,
    required this.title,
    required this.file,
    this.withDownload = false,
  }) : urlVideo = null;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  final _isDownloading = ValueNotifier<bool>(false);
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.file != null) {
        _videoPlayerController = VideoPlayerController.file(widget.file!);
      } else if (widget.urlVideo != null) {
        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.urlVideo!),
        );
      } else {
        throw Exception("Tidak ada sumber video");
      }

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControlsOnInitialize: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Icon(
              Icons.broken_image_rounded,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 48,
            ),
          );
        },
      );

      setState(() {});
    } catch (e) {
      setState(() {
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _isDownloading.dispose();
    super.dispose();
  }

  // --- Fungsi Unduh Video ---
  Future<void> _downloadVideo(BuildContext context) async {
    _isDownloading.value = true;

    if (widget.urlVideo == null && widget.file == null) {
      showSnackBar(
        context,
        'Tidak ada video untuk diunduh.',
        type: SnackBarType.failure,
      );
      _isDownloading.value = false;
      return;
    }

    try {
      dynamic result;
      final fileName = "LaporMin_${DateTime.now().millisecondsSinceEpoch}.mp4";

      if (widget.urlVideo != null) {
        // 1. Jika dari URL, simpan ke file temp dulu karena ukuran video bisa memicu OutOfMemory
        // jika disimpan langsung ke bentuk bytes seperti gambar.
        final response = await http.get(Uri.parse(widget.urlVideo!));
        if (response.statusCode != 200)
          throw Exception('Gagal mengunduh video');

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(response.bodyBytes);

        // Gunakan .saveFile khusus untuk video
        result = await ImageGallerySaverPlus.saveFile(tempFile.path);

        // Hapus file temporary setelah berhasil disimpan ke galeri
        if (await tempFile.exists()) await tempFile.delete();
      } else if (widget.file != null) {
        // 2. Jika dari file lokal, langsung saveFile path-nya
        result = await ImageGallerySaverPlus.saveFile(widget.file!.path);
      }

      if (context.mounted) {
        final isSuccess = result['isSuccess'] == true;
        showSnackBar(
          context,
          isSuccess
              ? 'Video berhasil disimpan ke Galeri!'
              : 'Gagal menyimpan video.',
          type: isSuccess ? SnackBarType.success : SnackBarType.failure,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
          context,
          'Terjadi kesalahan saat menyimpan: $e',
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
                  onPressed: value ? null : () => _downloadVideo(context),
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
        ],
      ),
      body: _buildBody(color),
    );
  }

  Widget _buildBody(ColorScheme color) {
    if (widget.urlVideo == null && widget.file == null) {
      return SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Center(
          child: Text(
            'Tidak ada video',
            style: AppTextStyle.s14(color: color.surface),
          ),
        ),
      );
    }

    if (_isError) {
      return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: color.surfaceContainerHighest,
        child: Icon(
          Icons.broken_image_rounded,
          color: color.onSurfaceVariant,
          size: 48,
        ),
      );
    }

    // InteractiveViewer dihapus karena video controller (Chewie) sudah menangani
    // gesture ketukan (play/pause) dan slider. Menggunakan InteractiveViewer
    // akan membuat UI controller video kesulitan mendeteksi sentuhan jari.
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Hero(
        tag: widget.tag,
        child:
            _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
