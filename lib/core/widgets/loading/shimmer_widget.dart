import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width, height;
  final BorderRadiusGeometry? borderRadius;

  const ShimmerWidget({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: color.surfaceContainerHighest,
      highlightColor: color.surfaceContainer,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
