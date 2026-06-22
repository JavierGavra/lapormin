import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/widgets/button/notification_button.dart';

import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../route/navigate.dart';
import '../../utils/text_style/app_text_style.dart';
import '../avatar/profile_avatar.dart';

class AppSliverAppBar extends StatelessWidget {
  final String? title;

  const AppSliverAppBar({super.key, this.title});

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
        NotificationButton(),
        const SizedBox(width: 4),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => Navigate.push(context, const ProfilePage()),
              child: ProfileAvatar.verySmall(
                username: state.user?.username ?? "User",
                photoProfile: state.user?.photoProfile?.path,
              ),
            );
          },
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}
