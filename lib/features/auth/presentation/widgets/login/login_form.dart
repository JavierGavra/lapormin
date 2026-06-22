import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/utils/validator/input_validator.dart';
import 'package:lapormin/core/widgets/text_field/app_text_field.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.phoneController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFieldItem(
          color,
          label: "Nomor Telepon",
          field: AppTextField(
            controller: phoneController,
            hintText: "8xx-xxxx-xxxx",
            keyboardType: TextInputType.phone,
            validator: (value) => InputValidator.phone(value),
            prefixIcon: Icon(Icons.phone_outlined, color: color.secondary),
          ),
        ),
        const SizedBox(height: 20),
        _buildFieldItem(
          color,
          label: "Password",
          field: AppTextField(
            controller: passwordController,
            hintText: "Masukkan kata sandi",
            validator: (value) => InputValidator.password(value),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: color.secondary,
            ),
            isPassword: true,
          ),
        ),
        const SizedBox(height: 20),
        // Align(
        //   alignment: Alignment.bottomRight,
        //   child: TextButton(
        //     onPressed: () {},
        //     child: Text("Lupa kata sandi?", style: AppTextStyle.s12()),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFieldItem(
    ColorScheme color, {
    required String label,
    required Widget field,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: AppTextStyle.s12(
              fontWeight: FontWeight.w600,
              color: color.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        field,
      ],
    );
  }
}
