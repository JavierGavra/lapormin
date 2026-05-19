import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:lapormin/core/layouts/main_layout.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import '../bloc/auth/auth_bloc.dart';
import '../pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _listerner(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.authenticated) {
      context.pushReplacementTransition(
        type: PageTransitionType.fade,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        child: const MainLayout(),
      );
    } else if (state.status == AuthStatus.unauthenticated) {
      context.pushReplacementTransition(
        type: PageTransitionType.fade,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        child: const LoginPage(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: _listerner,
      child: Scaffold(
        backgroundColor: color.primary,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "LaporMin!",
                      style: TextStyle(
                        fontFamily: "Plus Jakarta Sans",
                        fontWeight: FontWeight.w800,
                        color: color.onPrimary,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "Made by ",
                    style: AppTextStyle.s12(
                      color: color.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: "Bengkel Koding",
                        style: AppTextStyle.s12(
                          color: color.onPrimary,
                          fontStyle: FontStyle.italic,
                          fontFamily: "Plus Jakarta Sans",
                          fontWeight: FontWeight.w700,
                        ),
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
}
