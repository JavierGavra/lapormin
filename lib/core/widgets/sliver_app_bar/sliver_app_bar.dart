import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';

class AppSliverAppBar extends StatelessWidget {
  final String profileUrl;
  final VoidCallback onNotificationTap;

  const AppSliverAppBar({
    super.key,
    required this.profileUrl,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SliverAppBar(
      floating: true,
      pinned: false,
      backgroundColor: color.surface,
      surfaceTintColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          "LaporMin!",
          style: AppTextStyle.s22(
            fontWeight: FontWeight.w800,
            color: color.primary,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: Icon(Icons.notifications_none_rounded, color: color.onSurface),
        ),
        const SizedBox(width: 4),
        CircleAvatar(radius: 16, backgroundImage: AssetImage(profileUrl)),
        const SizedBox(width: 24),
      ],
    );
  }
}
