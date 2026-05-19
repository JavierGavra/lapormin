import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';
import 'package:lapormin/core/utils/validator/input_validator.dart';
import 'package:lapormin/core/widgets/app_text_field/app_text_field.dart';
import 'package:lapormin/features/auth/presentation/widgets/custom_otp_text_field.dart';

class RegisterStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<Widget> textFields;

  const RegisterStep._({
    required this.icon,
    required this.title,
    required this.description,
    required this.textFields,
  });

  factory RegisterStep.username({required TextEditingController controller}) {
    return RegisterStep._(
      icon: Icons.person_outline_rounded,
      title: "Siapa nama kamu?",
      description: "Masukkan nama lengkap untuk akun kamu",
      textFields: [
        AppTextField(
          hintText: "Nama Lengkap",
          controller: controller,
          validator: (value) => InputValidator.empty(value),
        ),
      ],
    );
  }

  factory RegisterStep.phone({required TextEditingController controller}) {
    return RegisterStep._(
      icon: Icons.phone_outlined,
      title: "Nomor telepon",
      description: "Kami akan mengirim kode verifikasi ke nomor ini",
      textFields: [
        AppTextField(
          hintText: "8xx-xxxx-xxxx",
          controller: controller,
          keyboardType: TextInputType.phone,
          validator: (value) => InputValidator.phone(value),
        ),
      ],
    );
  }

  factory RegisterStep.password({
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  }) {
    return RegisterStep._(
      icon: Icons.lock_outline_rounded,
      title: "Buat kata sandi",
      description: "Minimal 8 karakter untuk keamanan akun",
      textFields: [
        AppTextField(
          hintText: "Minimal 8 karakter",
          controller: passwordController,
          validator: (value) => InputValidator.password(value),
          isPassword: true,
        ),
        AppTextField(
          hintText: "Konfirmasi kata sandi anda",
          controller: confirmPasswordController,
          validator: (value) =>
              InputValidator.confirmPassword(value, passwordController.text),
          isPassword: true,
        ),
      ],
    );
  }

  factory RegisterStep.otp({required TextEditingController controller}) {
    return RegisterStep._(
      icon: Icons.verified_user_outlined,
      title: "Verifikasi OTP",
      description: "Masukkan kode 6 digit yang dikirim ke nomor kamu",
      textFields: [CustomOtpTextField(controller: controller)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
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
