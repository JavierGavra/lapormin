import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.zero,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: WidgetStatePropertyAll<Color>(
          backgroundColor ?? color.surfaceContainer,
        ),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        iconSize: WidgetStatePropertyAll<double>(20),
      ),
    );
  }
}
