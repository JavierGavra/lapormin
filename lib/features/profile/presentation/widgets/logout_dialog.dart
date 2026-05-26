import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../core/utils/text_style/app_text_style.dart';
import '../../../../injection.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/profile/profile_bloc.dart';

Widget logoutDialog(BuildContext context) {
  final color = Theme.of(context).colorScheme;
  final size = MediaQuery.of(context).size;

  return BlocProvider(
    create: (context) => sl<ProfileBloc>(),
    child: BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          context.pushAndRemoveUntilTransition(
            duration: const Duration(milliseconds: 300),
            predicate: (route) => false,
            type: PageTransitionType.fade,
            curve: Curves.easeInOut,
            child: const LoginPage(),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Center(
              child: Container(
                width: 128,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2.2,
                      ),
                    ),
                    SizedBox(width: 12),
                    const Text(
                      'Keluar...',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: size.width * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Peringatan',
                    style: AppTextStyle.s20(
                      color: color.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Anda yakin ingin keluar dari akun ini?',
                    style: AppTextStyle.s14(color: color.onSurfaceVariant),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: color.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 40),
                            textStyle: AppTextStyle.s14(color: color.primary),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            context.read<ProfileBloc>().add(
                              ProfileLogoutRequested(),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: color.error,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: Size(double.infinity, 40),
                            textStyle: AppTextStyle.s14(color: color.error),
                          ),
                          child: const Text('Keluar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
