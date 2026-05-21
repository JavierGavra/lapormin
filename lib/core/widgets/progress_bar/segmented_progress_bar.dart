import 'package:flutter/material.dart';

class SegmentedProgressBar extends StatefulWidget {
  final int progress;
  final int segment;
  final Curve curve;

  const SegmentedProgressBar({
    super.key,
    required this.progress,
    required this.segment,
    this.curve = Curves.easeInOut,
  }) : assert(progress <= segment);

  @override
  State<SegmentedProgressBar> createState() => _SegmentedProgressBarState();
}

class _SegmentedProgressBarState extends State<SegmentedProgressBar> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 8,
          width: constraints.maxWidth,
          child: Row(
            spacing: 8,
            children: List.generate(widget.segment, (index) {
              final isActive = index < widget.progress;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: widget.curve,
                  decoration: BoxDecoration(
                    color: isActive
                        ? color.primary
                        : color.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
