import 'package:flutter/material.dart';
import '../../utils/app_text_style/app_text_style.dart';

class AppFilledButton extends StatelessWidget {
  final String text;
  final double? iconSize;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;

  const AppFilledButton({
    super.key,
    required this.text,
    this.iconSize,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
  });

  double get _effectiveIconSize => iconSize ?? 20;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            if (prefixIcon != null) Icon(prefixIcon, size: _effectiveIconSize),
            Text(text, style: AppTextStyle.s14(fontWeight: FontWeight.w700)),
            if (suffixIcon != null) Icon(suffixIcon, size: _effectiveIconSize),
          ],
        ),
      ),
    );
  }
}
