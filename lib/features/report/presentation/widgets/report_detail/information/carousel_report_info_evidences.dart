import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/widgets/image/image_viewer_page.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';
import 'package:lapormin/core/widgets/video/video_player_page.dart';
import 'package:lapormin/features/report/domain/entities/evidence.dart';

class CarouselReportInfoEvidences extends StatefulWidget {
  final List<Evidence> evidences;

  const CarouselReportInfoEvidences({super.key, required this.evidences});

  @override
  State<CarouselReportInfoEvidences> createState() =>
      _CarouselReportInfoEvidencesState();
}

class _CarouselReportInfoEvidencesState
    extends State<CarouselReportInfoEvidences> {
  final _controller = CarouselController();

  Timer? _carouselTimer;

  void _startAutoSlide() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        final double currentOffset = _controller.offset;
        final double maxScrollExtent = _controller.position.maxScrollExtent;
        double nextOffset = currentOffset + 200;

        if (currentOffset >= maxScrollExtent) {
          nextOffset = 0;
        }

        _controller.animateTo(
          nextOffset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: CarouselView.weightedBuilder(
        controller: _controller,
        itemSnapping: true,
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        flexWeights: widget.evidences.length > 1 ? [5, 1] : [1],
        itemCount: widget.evidences.length,
        itemBuilder: (context, index) {
          return _buildEvidenceCard(context, widget.evidences[index]);
        },
      ),
    );
  }

  Widget _buildEvidenceCard(BuildContext context, Evidence evidence) {
    print("Evidence URL: ${evidence.url}"); // Debugging line
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Hero(
          tag: evidence.previewUrl,
          child: GestureDetector(
            onTap: () {
              Navigate.push(
                context,
                (evidence.isVideo)
                    ? VideoPlayerPage.network(
                        tag: evidence.url,
                        title: "Bukti Lapangan",
                        withDownload: true,
                        urlVideo: evidence.url,
                      )
                    : ImageViewerPage.network(
                        tag: evidence.url,
                        title: "Bukti Lapangan",
                        withDownload: true,
                        urlImage: evidence.previewUrl,
                      ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  evidence.previewUrl,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return ShimmerWidget();
                      },
                ),

                if (evidence.isVideo)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
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
