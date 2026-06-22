import 'package:flutter/material.dart';

import '../../utils/text_style/app_text_style.dart';
import '../button/app_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AppBar(
      titleSpacing: 16,
      leadingWidth: 24 + 40,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      surfaceTintColor: Colors.transparent,
      backgroundColor: color.surfaceContainerLowest,
      actionsPadding: const EdgeInsets.only(right: 24),
      title: Text(
        title,
        style: AppTextStyle.s16(
          fontWeight: FontWeight.w600,
          color: color.primary,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Center(
          child: SizedBox(width: 40, height: 40, child: AppBackButton()),
        ),
      ),
    );
  }
}
