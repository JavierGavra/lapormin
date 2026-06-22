import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/button/app_back_button.dart';

class AdminSliverAppBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final String title;

  const AdminSliverAppBar({
    super.key,
    required this.onBackTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: false,
      floating: true,
      snap: true,
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
      elevation: 5,
    );
  }
}
