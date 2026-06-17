import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../route/navigate.dart';
import '../../utils/text_style/app_text_style.dart';
import '../avatar/profile_avatar.dart';

class AppSliverAppBar extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final String? title;

  const AppSliverAppBar({
    super.key,
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
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => Navigate.push(context, const ProfilePage()),
              child: ProfileAvatar.verySmall(
                username: state.user?.username ?? "User",
                photoProfile: state.user?.photoProfile,
              ),
            );
          },
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}
