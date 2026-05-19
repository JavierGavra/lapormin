import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/app_filled_button/app_filled_button.dart';
import 'package:lapormin/core/widgets/success/success_screen.dart';
import 'package:lapormin/features/auth/presentation/widgets/auth_switch_button.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: color.primary,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        spreadRadius: -4,
                        offset: const Offset(0, 4),
                        color: color.shadow.withValues(alpha: 0.1),
                      ),
                      BoxShadow(
                        blurRadius: 15,
                        spreadRadius: -3,
                        offset: const Offset(0, 10),
                        color: color.shadow.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Selamat Datang",
                  style: AppTextStyle.s22(
                    fontWeight: FontWeight.w700,
                    fontFamily: "Plus Jakarta Sans",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Laportkan hal di sekitar anda pada mimin!",
                  style: AppTextStyle.s14(),
                ),
                const SizedBox(height: 40),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "Nomor Telepon",
                        style: AppTextStyle.s12(
                          fontWeight: FontWeight.w600,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "8xx-xxxx-xxxx",
                        filled: true,
                        fillColor: color.surfaceContainerLowest,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: color.secondary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.error),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        "Password",
                        style: AppTextStyle.s12(
                          fontWeight: FontWeight.w600,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Masukkan kata sandi",
                        filled: true,
                        fillColor: color.surfaceContainerLowest,
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: color.secondary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.visibility_off_outlined),
                          color: color.outline,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.outline),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color.error),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Lupa kata sandi?", style: AppTextStyle.s12()),
                  ),
                ),
                const SizedBox(height: 24),
                AppFilledButton(
                  text: "Masuk",
                  onPressed: () {
                    context.pushTransition(
                      type: PageTransitionType.bottomToTop,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      child: SuccessScreen(
                        title: 'Akun Sudah Dibuat',
                        description: 'Silahkan login dengan akun baru!',
                        onBack: () {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        },
                      ),
                    );
                  },
                  suffixIcon: Icons.arrow_forward_rounded,
                  iconSize: 16,
                ),
                const SizedBox(height: 12),
                AuthSwitchButton.toRegister(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
