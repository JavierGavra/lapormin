import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final double? horizontal;
  final double? vertical;
  final Color? backgroundColor;
  final Widget child;

  const AppChip({
    super.key,
    required this.child,
    this.backgroundColor,
    this.horizontal,
    this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal ?? 8,
        vertical: vertical ?? 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
