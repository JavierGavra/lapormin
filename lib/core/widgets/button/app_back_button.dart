import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final void Function()? onPressed;

  const AppBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BackButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(color.surfaceContainer),
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        iconSize: WidgetStatePropertyAll<double>(20),
      ),
    );
  }
}
