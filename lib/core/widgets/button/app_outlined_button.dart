import 'package:flutter/material.dart';
import '../../utils/text_style/app_text_style.dart';

class AppOutlinedButton extends StatelessWidget {
  final bool enabled;
  final String text;
  final double? iconSize;
  final Color? foregroundColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final bool _isLoading;

  const AppOutlinedButton({
    super.key,
    this.enabled = true,
    required this.text,
    this.iconSize,
    this.foregroundColor,
    this.prefixIcon,
    this.suffixIcon,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
  }) : _isLoading = false;

  const AppOutlinedButton.loading({super.key})
    : _isLoading = true,
      enabled = false,
      text = "",
      onPressed = null,
      prefixIcon = null,
      suffixIcon = null,
      iconSize = null,
      foregroundColor = null,
      onLongPress = null,
      onHover = null,
      onFocusChange = null;

  double get _effectiveIconSize => iconSize ?? 20;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      height: 56,
      width: _isLoading ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          side: enabled
              ? BorderSide(color: foregroundColor ?? color.primary)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? SizedBox.square(
                dimension: 24,
                child: const CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  if (prefixIcon != null)
                    Icon(prefixIcon, size: _effectiveIconSize),
                  Text(
                    text,
                    style: AppTextStyle.s14(fontWeight: FontWeight.w700),
                  ),
                  if (suffixIcon != null)
                    Icon(suffixIcon, size: _effectiveIconSize),
                ],
              ),
      ),
    );
  }
}
