import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/app_text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/app_back_button/app_back_button.dart';
import 'package:lapormin/core/widgets/app_filled_button/app_filled_button.dart';
import 'package:lapormin/core/widgets/progress_bar/progress_bar.dart';
import 'package:lapormin/core/widgets/success/success_screen.dart';
import 'package:lapormin/injection.dart';
import 'package:page_transition/page_transition.dart';

import '../bloc/register/register_bloc.dart';
import '../widgets/register_step.dart';
import '../widgets/auth_switch_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _pageController = PageController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final List<Widget> _steps;

  void _listener(BuildContext context, RegisterState state) {
    print("${state.username != null} ${state.phone} ${state.password}");
    if (state.status == RegisterStatus.next) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (state.status == RegisterStatus.previous) {
      switch (state.currentStep) {
        case 0:
          Navigator.pop(context);
        case 1:
          _phoneController.clear();
          break;
        case 2:
          _passwordController.clear();
          _confirmPasswordController.clear();
          break;
      }

      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else if (state.status == RegisterStatus.success) {
      context.pushTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        child: SuccessScreen(
          title: 'Akun Sudah Dibuat',
          description: 'Silahkan login dengan akun baru!',
          onBack: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      );
    } else if (state.status == RegisterStatus.failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? "Registration failed")),
      );
    }
  }

  void _nextStep(BuildContext context, int currentStep) {
    if (currentStep < _steps.length) {
      if (_formKey.currentState!.validate()) {
        final event = switch (currentStep) {
          1 => RegisterUsernameSubmit(_usernameController.text),
          2 => RegisterPhoneSubmit(_phoneController.text),
          3 => RegisterPasswordSubmit(_passwordController.text),
          _ => null,
        };
        if (event != null) context.read<RegisterBloc>().add(event);
      }
    } else {
      context.read<RegisterBloc>().add(RegisterOtpSubmit(_otpController.text));
    }
  }

  void _prevStep(BuildContext context) {
    context.read<RegisterBloc>().add(RegisterPreviousStep());
  }

  @override
  void initState() {
    super.initState();
    _steps = [
      RegisterStep.username(controller: _usernameController),
      RegisterStep.phone(controller: _phoneController),
      RegisterStep.password(
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
      ),
      RegisterStep.otp(controller: _otpController),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => sl<RegisterBloc>(),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: _listener,
          child: Builder(
            builder: (context) {
              return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  _prevStep(context);
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            itemCount: _steps.length,
                            itemBuilder: (context, index) => _steps[index],
                          ),
                        ),
                      ),
                      _buildButton(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final color = Theme.of(context).colorScheme;
    return BlocSelector<RegisterBloc, RegisterState, int>(
      selector: (state) => state.currentStep,
      builder: (context, currentStep) {
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
      },
    );
  }

  Widget _buildButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              state.status == RegisterStatus.loading
                  ? const AppFilledButton.loading()
                  : AppFilledButton(
                      text: state.currentStep == 4 ? "Buat Akun" : "Lanjutkan",
                      onPressed: () => _nextStep(context, state.currentStep),
                      suffixIcon: Icons.arrow_forward_rounded,
                      iconSize: 16,
                    ),
              const SizedBox(height: 12),
              if (state.currentStep == 1) AuthSwitchButton.toLogin(),
            ],
          ),
        );
      },
    );
  }
}
