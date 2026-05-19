import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class CustomOtpTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomOtpTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return OtpTextField(
      numberOfFields: 6,
      filled: true,
      fieldWidth: 48,
      showFieldAsBox: true,
      margin: EdgeInsets.zero,
      borderWidth: 1,
      borderColor: color.primary,
      focusedBorderColor: color.primary,
      enabledBorderColor: color.outline,
      cursorColor: color.primary,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      borderRadius: BorderRadius.circular(12),
      textStyle: AppTextStyle.s14(),
      onSubmit: (code) {
        controller.text = code;
      },
    );
  }
}
