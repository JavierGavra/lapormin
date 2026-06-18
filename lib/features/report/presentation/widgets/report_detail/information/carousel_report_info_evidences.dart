import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/widgets/image/image_viewer_page.dart';
import 'package:lapormin/core/widgets/loading/shimmer_widget.dart';

class CarouselReportInfoEvidences extends StatefulWidget {
  final List<String> evidences;

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
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: widget.evidences[index],
              child: GestureDetector(
                onTap: () {
                  Navigate.push(
                    context,
                    ImageViewerPage.network(
                      tag: widget.evidences[index],
                      title: "Bukti Lapangan",
                      withDownload: true,
                      urlImage: widget.evidences[index],
                    ),
                  );
                },
                child: Image.network(
                  widget.evidences[index],
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
          ),
        ),
      ),
    );
  }
}
