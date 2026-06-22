import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/utils/validator/input_validator.dart';
import 'package:lapormin/core/widgets/button/app_back_button.dart';
import 'package:lapormin/core/widgets/button/app_filled_button.dart';
import 'package:lapormin/core/widgets/loading/fullscreen_loading_overlay.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';
import 'package:lapormin/core/widgets/text_field/app_text_field.dart';
import 'package:lapormin/features/profile/presentation/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:lapormin/injection.dart';

class EditProfilePage extends StatefulWidget {
  final String currentUsername;

  const EditProfilePage({super.key, required this.currentUsername});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void _listener(BuildContext context, EditProfileState state) {
    if ((state.isSuccess || state.isFailure) && isLoading) {
      isLoading = false;
      FullscreenLoadingOverlay.hide(context);
    }

    if (state.isSuccess) {
      showSnackBar(
        context,
        'Profil berhasil diperbarui',
        type: SnackBarType.success,
      );
      Navigator.pop(context, _usernameController.text);
    } else if (state.isFailure) {
      showSnackBar(
        context,
        state.errorMessage ?? 'Terjadi kesalahan',
        type: SnackBarType.failure,
      );
    }
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<EditProfileBloc>().add(
        EditProfileUsernameChanged(_usernameController.text),
      );

      isLoading = true;
      FullscreenLoadingOverlay.show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.currentUsername;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => sl<EditProfileBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 16,
              leadingWidth: 24 + 40,
              shadowColor: Colors.black.withValues(alpha: 0.25),
              surfaceTintColor: Colors.transparent,
              backgroundColor: color.surfaceContainerLowest,
              actionsPadding: const EdgeInsets.only(right: 24),
              title: Text(
                "Edit Profil",
                style: AppTextStyle.s16(
                  fontWeight: FontWeight.w600,
                  color: color.primary,
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: AppBackButton(),
                  ),
                ),
              ),
            ),
            body: BlocListener<EditProfileBloc, EditProfileState>(
              listener: _listener,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          "Nama Pengguna",
                          style: AppTextStyle.s12(
                            fontWeight: FontWeight.w600,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        controller: _usernameController,
                        hintText: "Nama Lengkap",
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => InputValidator.empty(value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(24),
              child: AppFilledButton(
                text: "Simpan",
                onPressed: () => _onSubmit(context),
              ),
            ),
          );
        },
      ),
    );
  }
}
