import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/profile/presentation/pages/profile_page.dart';
import 'package:page_transition/page_transition.dart';

class AppSliverAppBar extends StatelessWidget {
  final String profileUrl;
  final VoidCallback onNotificationTap;
  final String? title;

  const AppSliverAppBar({
    super.key,
    required this.profileUrl,
    required this.onNotificationTap,
    this.title,
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
          title ?? "LaporMin!",
          style: AppTextStyle.s20(
            fontWeight: FontWeight.w700,
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
        GestureDetector(
          onTap: () {
            context.pushTransition(
              duration: const Duration(milliseconds: 300),
              type: PageTransitionType.rightToLeft,
              curve: Curves.easeOut,
              child: const ProfilePage(),
            );
          },
          child: CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(profileUrl),
          ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}
