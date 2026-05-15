import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/app_back_button/app_back_button.dart';
import 'package:lapormin/core/widgets/app_filled_button/app_filled_button.dart';
import 'package:lapormin/core/widgets/progress_bar/progress_bar.dart';
import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final pageController = PageController();
  int currentStep = 1;

  List<Widget> get steps => [
    _buildStep(
      icon: Icons.person_outline_rounded,
      title: "Siapa nama kamu?",
      description: "Masukkan nama lengkap untuk akun kamu",
    ),
    _buildStep(
      icon: Icons.phone_outlined,
      title: "Nomor telepon",
      description: "Kami akan mengirim kode verifikasi ke nomor ini",
    ),
    _buildStep(
      icon: Icons.lock_outline_rounded,
      title: "Buat kata sandi",
      description: "Minimal 8 karakter untuk keamanan akun",
    ),
    _buildStep(
      icon: Icons.verified_user_outlined,
      title: "Verifikasi OTP",
      description: "Masukkan kode 6 digit yang dikirim ke nomor kamu",
    ),
  ];

  void _nextStep() {
    if (currentStep < steps.length) {
      setState(() => currentStep++);
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // Handle completion logic
    }
  }

  void _prevStep() {
    if (currentStep > 1) {
      setState(() => currentStep--);
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: currentStep < 1,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _prevStep();
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: steps,
                ),
              ),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppBackButton(),
              Text(
                "$currentStep / 4",
                style: AppTextStyle.s14(
                  color: color.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProgressBar(progress: currentStep / 4),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
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
          TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Nama Lengkap",
              hintStyle: AppTextStyle.s14(color: color.onSurfaceVariant),
              filled: true,
              fillColor: color.surfaceContainerLowest,
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
    );
  }

  Widget _buildButton() {
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          AppFilledButton(
            text: "Lanjutkan",
            onPressed: _nextStep,
            suffixIcon: Icons.arrow_forward_rounded,
            iconSize: 16,
          ),
          const SizedBox(height: 12),
          if (currentStep == 1)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text.rich(
                  TextSpan(
                    text: "Sudah punya akun? ",
                    children: [
                      TextSpan(
                        text: "Masuk",
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
            ),
        ],
      ),
    );
  }
}
