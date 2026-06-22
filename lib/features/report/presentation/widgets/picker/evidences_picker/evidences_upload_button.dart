import 'package:flutter/material.dart';

import '../../../../../../core/utils/text_style/app_text_style.dart';

class EvidencesUploadButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onTap;
  final bool _isFieldOfficer;

  const EvidencesUploadButton({
    super.key,
    required this.isDisabled,
    required this.onTap,
  }) : _isFieldOfficer = false;

  const EvidencesUploadButton.fieldOfficer({
    super.key,
    required this.isDisabled,
    required this.onTap,
  }) : _isFieldOfficer = true;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    final backgroundColor = (isDisabled)
        ? color.onSurface.withValues(alpha: 0.1)
        : (_isFieldOfficer)
        ? color.primaryContainer
        : color.primary;

    final foregroundColor = (isDisabled)
        ? color.onSurface.withValues(alpha: 0.38)
        : (_isFieldOfficer)
        ? color.onPrimaryContainer
        : color.onPrimary;

    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: _isFieldOfficer ? Border.all(color: color.primary) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: _isFieldOfficer ? 24 : 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 32,
                  color: foregroundColor,
                ),
                Text(
                  "Ambil Foto/Video",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.s14(
                    fontWeight: _isFieldOfficer
                        ? FontWeight.w600
                        : FontWeight.w700,
                    color: foregroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
