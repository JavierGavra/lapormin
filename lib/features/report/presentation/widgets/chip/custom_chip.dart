import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const CustomChip({super.key, required this.child, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? color.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
