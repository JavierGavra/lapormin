import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/button/app_back_button.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:lapormin/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:lapormin/features/profile/presentation/pages/change_password_page.dart';
import 'package:lapormin/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:lapormin/features/profile/presentation/widgets/profile_header.dart';
import 'package:lapormin/features/profile/presentation/widgets/profile_info.dart';
import 'package:lapormin/features/profile/presentation/widgets/profile_actions.dart';
import 'package:lapormin/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:lapormin/injection.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _onEditProfile(BuildContext context, String currentUsername) async {
    final changed = await Navigate.push(
      context,
      EditProfilePage(currentUsername: currentUsername),
    );

    if (changed != null && context.mounted) {
      context.read<ProfileBloc>().add(ProfileOpenned());
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => sl<ProfileBloc>()..add(ProfileOpenned()),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // RepaintBoundary(
                      //   child: SvgPicture.asset(
                      //     'assets/images/backgrounds/success_background.svg',
                      //     width: double.infinity,
                      //   ),
                      // ),
                      Image.asset(
                        'assets/images/backgrounds/success_background.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      BlocConsumer<ProfileBloc, ProfileState>(
                        listener: (context, state) {
                          if (state.status == ProfileStatus.avatarSuccess) {
                            context.read<AuthBloc>().add(AuthCheckRequested());
                            showSnackBar(
                              context,
                              'Foto profil berhasil diubah!',
                              type: SnackBarType.success,
                            );
                          }
                          if (state.status == ProfileStatus.failure) {
                            showSnackBar(
                              context,
                              state.errorMessage ?? 'Terjadi kesalahan',
                              type: SnackBarType.failure,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (!state.isSuccess) {
                            return const CircularProgressIndicator();
                          }

                          return Column(
                            spacing: 24,
                            children: [
                              _buildLeading(context),
                              ProfileHeader(
                                photoProfile: state.profile!.photoProfile,
                                username: state.profile!.username,
                              ),
                              ProfileInfo(
                                phoneNumber: state.profile!.phoneNumber,
                                reportAmount: state.profile!.reportAmount,
                                createdAt: state.profile!.createdAt,
                              ),
                              ProfileActions(
                                items: [
                                  ProfileActionItem(
                                    icon: Icons.person_outline_rounded,
                                    label: 'Edit Profil',
                                    onTap: () => _onEditProfile(
                                      context,
                                      state.profile!.username,
                                    ),
                                  ),
                                  ProfileActionItem(
                                    icon: Icons.lock_person_outlined,
                                    label: 'Ganti Password',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ChangePasswordPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              _buildLogoutButton(context),
                              const Spacer(),
                              _buildVersionInfo(color),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Align(
      alignment: Alignment.topLeft,
      child: Visibility(
        visible: canPop,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 18),
          child: AppBackButton(),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => logoutDialog(context),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 40,
                  child: Icon(Icons.logout_rounded, color: color.error),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Keluar',
                    style: AppTextStyle.s14(
                      fontWeight: FontWeight.w500,
                      color: color.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionInfo(ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(
        'v1.0 - Build 2025.05.07',
        style: AppTextStyle.s12(color: color.onSurfaceVariant),
      ),
    );
  }
}
