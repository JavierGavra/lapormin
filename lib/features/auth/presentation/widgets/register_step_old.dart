import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';

class RegisterStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Widget> textFields;

  const RegisterStep.username({super.key, required this.textFields})
    : icon = Icons.person_outline_rounded,
      title = "Siapa nama kamu?",
      description = "Masukkan nama lengkap untuk akun kamu";

  const RegisterStep.phone({super.key, required this.textFields})
    : icon = Icons.phone_outlined,
      title = "Nomor telepon",
      description = "Kami akan mengirim kode verifikasi ke nomor ini";

  const RegisterStep.password({super.key, required this.textFields})
    : icon = Icons.lock_outline_rounded,
      title = "Buat kata sandi",
      description = "Minimal 8 karakter untuk keamanan akun";

  const RegisterStep.otp({super.key, required this.textFields})
    : icon = Icons.verified_user_outlined,
      title = "Verifikasi OTP",
      description = "Masukkan kode 6 digit yang dikirim ke nomor kamu";

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return _buildStep(color: color);
  }

  Widget _buildStep({required ColorScheme color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color.onPrimaryContainer, size: 28),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTextStyle.s24(
              fontWeight: FontWeight.w700,
              fontFamily: "Plus Jakarta Sans",
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: AppTextStyle.s14()),
          const SizedBox(height: 32),
          Column(spacing: 8, children: textFields),
        ],
      ),
    );
  }
}
