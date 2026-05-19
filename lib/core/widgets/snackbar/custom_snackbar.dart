import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

SnackBar _createSnackBar(
  BuildContext context,
  SnackBarType type,
  String title,
) {
  final color = Theme.of(context).colorScheme;
  Widget content = SizedBox();
  Color? backgroundColor;

  if (type == SnackBarType.success) {
    backgroundColor = color.primary;
    content = Row(
      children: [
        Icon(Icons.check_circle, size: 18, color: color.inversePrimary),
        SizedBox(width: 16),
        Text(title, style: AppTextStyle.s14(color: color.onInverseSurface)),
      ],
    );
  } else if (type == SnackBarType.failure) {
    backgroundColor = color.error;
    content = Row(
      children: [Text(title, style: AppTextStyle.s14(color: color.onError))],
    );
  }

  return SnackBar(
    duration: const Duration(seconds: 2),
    backgroundColor: backgroundColor,
    content: content,
    showCloseIcon: true,
  );
}

enum SnackBarType { success, failure }

void showSnackBar(
  BuildContext context,
  String title, {
  SnackBarType type = SnackBarType.success,
}) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(_createSnackBar(context, type, title));
}
