import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';
import '../pages/register_page.dart';

class AuthSwitchButton extends StatelessWidget {
  final bool _isToLogin;

  const AuthSwitchButton.toLogin({super.key}) : _isToLogin = true;

  const AuthSwitchButton.toRegister({super.key}) : _isToLogin = false;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        if (_isToLogin) {
          Navigator.pop(context);
        } else {
          context.pushTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: const RegisterPage(),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text.rich(
          TextSpan(
            text: _isToLogin ? "Belum punya akun? " : "Sudah punya akun? ",
            children: [
              TextSpan(
                text: _isToLogin ? "Daftar" : "Masuk",
                style: TextStyle(
                  color: color.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            style: AppTextStyle.s12(),
          ),
        ),
      ),
    );
  }
}
