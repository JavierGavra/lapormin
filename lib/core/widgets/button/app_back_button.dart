import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Color? backgroundColor;
  final void Function()? onPressed;

  const AppBackButton({super.key, this.backgroundColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox.fromSize(
      size: Size.square(40),
      child: BackButton(
        onPressed: onPressed,
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
      ),
    );
  }
}
