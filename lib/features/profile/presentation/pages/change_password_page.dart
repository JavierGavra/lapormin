import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/button/app_back_button.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/core/widgets/success/success_page.dart';
import 'package:lapormin/features/profile/presentation/bloc/change_password/change_password_bloc.dart';
import 'package:lapormin/injection.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChangePasswordBloc>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool get _isFormValid =>
      _oldPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty;

  bool get _isPasswordMatch =>
      _newPasswordController.text == _confirmPasswordController.text;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, color),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubah Kata Sandi',
                      style: AppTextStyle.s20(
                        fontWeight: FontWeight.w700,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pastikan kata sandi baru Anda kuat dan mudah diingat.',
                      style: AppTextStyle.s14(color: color.onSurfaceVariant),
                    ),
                    const SizedBox(height: 32),
                    _buildPasswordField(
                      label: 'Kata Sandi Saat Ini',
                      controller: _oldPasswordController,
                      obscureText: _obscureOld,
                      color: color,
                      onToggle: () =>
                          setState(() => _obscureOld = !_obscureOld),
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: 'Kata Sandi Baru',
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      color: color,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: 'Konfirmasi Kata Sandi Baru',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      color: color,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      errorText:
                          (_newPasswordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty &&
                              !_isPasswordMatch)
                          ? 'Kata sandi tidak cocok'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(context, color),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
      child: Align(alignment: Alignment.topLeft, child: AppBackButton()),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required ColorScheme color,
    required VoidCallback onToggle,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.s14(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            filled: true,
            fillColor: color.surfaceContainerLowest,
            hintText: 'Masukkan $label',
            hintStyle: TextStyle(
              color: color.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            errorText: errorText,
            prefixIcon: const Icon(Icons.lock_outline, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: color.onSurfaceVariant,
                size: 20,
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color.error),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, ColorScheme color) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
          listener: (context, state) {
            if (state.status == ChangePasswordStatus.success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessPage(
                    title: 'Password Berhasil Diubah!',
                    description:
                        'Silakan gunakan password baru Anda untuk login berikutnya.',
                    onBack: () => Navigator.pop(context),
                  ),
                ),
              );
            } else if (state.status == ChangePasswordStatus.failure) {
              showSnackBar(
                context,
                state.errorMessage ?? "Terjadi kesalahan",
                type: SnackBarType.failure,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state.status == ChangePasswordStatus.loading;

            return FilledButton(
              onPressed: (_isFormValid && _isPasswordMatch && !isLoading)
                  ? () {
                      context.read<ChangePasswordBloc>().add(
                        SubmitChangePassword(
                          oldPassword: _oldPasswordController.text,
                          newPassword: _newPasswordController.text,
                        ),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: color.primary,
                disabledBackgroundColor: color.surfaceContainerHighest,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Simpan Password',
                      style: AppTextStyle.s14(
                        fontWeight: FontWeight.w700,
                        color: (_isFormValid && _isPasswordMatch)
                            ? color.onPrimary
                            : color.onSurface,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
