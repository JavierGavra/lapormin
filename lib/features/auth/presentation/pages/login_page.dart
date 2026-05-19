import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import 'package:lapormin/injection.dart';
import 'package:lapormin/main.dart';
import 'package:lapormin/core/constants/user_role_enum.dart';
import 'package:lapormin/core/layouts/main_layout.dart';
import 'package:lapormin/core/widgets/button/app_filled_button.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/button/auth_switch_button.dart';
import '../widgets/login/login_form.dart';
import '../widgets/login/login_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _listener(BuildContext context, LoginState state) {
    if (state.status == LoginStatus.success) {
      final destination = switch (state.role) {
        UserRole.informant => const MainLayout(),
        UserRole.admin => const TempPage(),
        UserRole.fieldOfficer => const TempPage(),
        _ => const TempPage(),
      };

      context.pushAndRemoveUntilTransition(
        type: PageTransitionType.bottomToTop,
        predicate: (route) => false,
        child: destination,
      );
    } else if (state.status == LoginStatus.failure) {
      showSnackBar(
        context,
        state.errorMessage ?? "Login gagal.",
        type: SnackBarType.failure,
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => sl<LoginBloc>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocListener<LoginBloc, LoginState>(
          listener: _listener,
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginHeader(),
                    LoginForm(
                      phoneController: _phoneController,
                      passwordController: _passwordController,
                    ),
                    const SizedBox(height: 24),
                    ..._buildAction(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAction(BuildContext context) {
    return [
      BlocSelector<LoginBloc, LoginState, LoginStatus>(
        selector: (state) => state.status,
        builder: (context, status) {
          return status == LoginStatus.loading
              ? AppFilledButton.loading()
              : AppFilledButton(
                  text: "Masuk",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<LoginBloc>().add(
                        LoginSubmitted(
                          phone: _phoneController.text,
                          password: _passwordController.text,
                        ),
                      );
                    }
                  },
                  suffixIcon: Icons.arrow_forward_rounded,
                  iconSize: 16,
                );
        },
      ),
      const SizedBox(height: 12),
      AuthSwitchButton.toRegister(),
    ];
  }
}
