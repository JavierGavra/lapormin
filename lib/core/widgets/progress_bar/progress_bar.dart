import 'package:flutter/material.dart';

class ProgressBar extends StatefulWidget {
  final double progress;
  final Curve curve;

  const ProgressBar({
    super.key,
    required this.progress,
    this.curve = Curves.easeInOut,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 6,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: color.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: widget.curve,
            width: widget.progress * constraints.maxWidth,
            decoration: BoxDecoration(
              color: color.primary,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      },
    );
  }
}
