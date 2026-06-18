import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/card/information_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:lapormin/core/widgets/success/success_page.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/add_field_officer/add_field_officer_bloc.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/add_field_officer/add_field_officer_event.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/add_field_officer/add_field_officer_state.dart';

class AddFieldOfficerPage extends StatefulWidget {
  const AddFieldOfficerPage({super.key});

  @override
  State<AddFieldOfficerPage> createState() => _AddFieldOfficerPageState();
}

class _AddFieldOfficerPageState extends State<AddFieldOfficerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Column(
        children: [
          _buildHeader(context, color),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InformationCard(
                    title: 'PERNYATAAN TANGGUNG JAWAB',
                    description:
                        'Dengan mendaftarkan petugas lapangan, Anda menyatakan bahwa data yang diberikan adalah akurat dan petugas tersebut berwenang untuk menangani laporan lapangan sesuai ketentuan yang berlaku.',
                    icon: Icons.work_outline,
                    type: InformationCardType.warning,
                  ),

                  const SizedBox(height: 24),
                  _buildFormContainer(color),
                  const SizedBox(height: 24),
                  _buildNotes(color),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildSubmitButton(color),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme color) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 16,
        left: 24,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_back, color: color.onSurface, size: 20),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Daftar Petugas Lapangan',
            style: AppTextStyle.s16(
              color: color.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer(ColorScheme color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.onPrimary,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Petugas',
            style: AppTextStyle.s16(
              color: color.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Isi formulir di bawah ini dengan lengkap dan benar',
            style: AppTextStyle.s12(color: color.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          Text(
            'Nama Petugas Lapangan',
            style: AppTextStyle.s14(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Nama Lengkap',
              hintStyle: TextStyle(color: color.onSurfaceVariant),
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Nomor Telepon',
            style: AppTextStyle.s14(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '8xx-xxxx-xxxx',
              hintStyle: TextStyle(color: color.onSurfaceVariant),
              prefixIcon: const Icon(Icons.call),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: color.outline),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(ColorScheme color) {
    Widget buildBulletPoint(String text, {TextStyle? style}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0, left: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•  ',
              style: AppTextStyle.s14(
                color: color.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: style ?? AppTextStyle.s14(color: color.onSurfaceVariant),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan :',
          style: AppTextStyle.s14(
            color: color.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),

        buildBulletPoint(
          'Password sementara dibuat otomatis oleh sistem.',
          style: AppTextStyle.s14(
            color: color.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
        buildBulletPoint(
          'Sistem akan meminta petugas mengganti password saat login pertama.',
          style: AppTextStyle.s14(
            color: color.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
        buildBulletPoint(
          'Pastikan Anda membagikannya kepada petugas.',
          style: AppTextStyle.s14(
            color: color.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ColorScheme color) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 24,
        ),

        child: BlocConsumer<AddFieldOfficerBloc, AddFieldOfficerState>(
          listener: (context, state) {
            if (state is AddFieldOfficerSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SuccessPage(
                    title: 'Petugas Telah Di Daftarkan',
                    description: 'Silahkan login dengan akun baru!',
                    extraWidget: _buildPasswordBox(state.generatedPassword),
                    autoBack: false,
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            } else if (state is AddFieldOfficerFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AddFieldOfficerLoading;

            return FilledButton(
              onPressed: (_isFormValid && !isLoading)
                  ? () {
                      context.read<AddFieldOfficerBloc>().add(
                        SubmitFieldOfficer(
                          name: _nameController.text,
                          phone: _phoneController.text,
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
                      'Daftarkan Petugas',
                      style: AppTextStyle.s14(
                        fontWeight: FontWeight.w700,
                        color: _isFormValid ? color.onPrimary : color.onSurface,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPasswordBox(String password) {
    return Builder(
      builder: (activeContext) {
        final color = Theme.of(activeContext).colorScheme;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Password',
                style: AppTextStyle.s14(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 20,
                color: color.surfaceContainerHighest,
              ),
              const SizedBox(width: 12),

              Text(
                password,
                style: AppTextStyle.s14(fontWeight: FontWeight.w400),
              ),

              const SizedBox(width: 8),

              GestureDetector(
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: password));

                  if (activeContext.mounted) {
                    ScaffoldMessenger.of(activeContext).showSnackBar(
                      SnackBar(
                        content: const Text('Password berhasil disalin!'),
                        backgroundColor: color.primary,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Icon(Icons.content_copy, size: 20, color: color.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}
