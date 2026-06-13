import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/injection.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../core/constants/report_status_enum.dart';
import '../../../../core/utils/text_style/app_text_style.dart';
import '../../../../core/utils/validator/input_validator.dart';
import '../../../../core/widgets/button/app_back_button.dart';
import '../../../../core/widgets/button/app_filled_button.dart';
import '../../../../core/widgets/loading/fullscreen_loading_overlay.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../../../../core/widgets/success/success_page.dart';
import '../../../../core/widgets/text_field/app_text_field.dart';
import '../bloc/report_result_form/report_result_form_bloc.dart';
import '../widgets/chip/custom_chip.dart';
import '../widgets/picker/evidences_picker/evidences_picker.dart';

enum ReportResultFormType { fieldCheck, action }

class ReportResultFormPage extends StatefulWidget {
  final String? fieldCheckId;
  final String reportTitle;
  final ReportResultFormType type;

  const ReportResultFormPage({
    super.key,
    required this.type,
    required this.reportTitle,
    this.fieldCheckId,
  });

  @override
  State<ReportResultFormPage> createState() => _ReportResultFormPageState();
}

class _ReportResultFormPageState extends State<ReportResultFormPage> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _evidences = [];

  String get _title => switch (widget.type) {
    ReportResultFormType.fieldCheck => 'Buat Laporan',
    ReportResultFormType.action => 'Buat Laporan Akhir',
  };

  String get _subTitle => switch (widget.type) {
    ReportResultFormType.fieldCheck => 'Hasil Inspeksi',
    ReportResultFormType.action => 'Hasil Tindakan',
  };

  void _listener(BuildContext context, ReportResultFormState state) {
    if (state.isLoading) {
      FullscreenLoadingOverlay.show(context);
    } else if (state.isSuccess) {
      FullscreenLoadingOverlay.hide(context);
      context.pushTransition(
        type: PageTransitionType.bottomToTop,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        child: SuccessPage(
          title: switch (widget.type) {
            ReportResultFormType.fieldCheck => 'Hasil Inspeksi Terkirim',
            ReportResultFormType.action => 'Laporan Hasil Tindakan Terkirim',
          },
          description: 'Terimakasih atas kontribusinya.',
          onBack: () {
            Navigate.pop(context);
            Navigate.pop(context, true);
          },
        ),
      );
    } else if (state.isFailure) {
      FullscreenLoadingOverlay.hide(context);
      showSnackBar(context, state.errorMessage!, type: SnackBarType.failure);
    }
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_evidences.isEmpty) {
      final message = "Wajib berikan bukti lapangan";
      showSnackBar(context, message, type: SnackBarType.failure);
      return;
    }

    context.read<ReportResultFormBloc>().add(switch (widget.type) {
      ReportResultFormType.fieldCheck => ReportResultFormFieldCheckSubmitted(
        fieldCheckId: widget.fieldCheckId!,
        description: _descriptionController.text,
        evidences: _evidences,
      ),
      ReportResultFormType.action => ReportResultFormFinalReportSubmitted(
        description: _descriptionController.text,
        evidences: _evidences,
      ),
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => sl<ReportResultFormBloc>(),
      child: BlocListener<ReportResultFormBloc, ReportResultFormState>(
        listener: _listener,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 16,
            leadingWidth: 24 + 40, // (Padding kiri) + (Lebar tombol)
            surfaceTintColor: Colors.transparent,
            actionsPadding: const EdgeInsets.only(right: 24),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title, style: AppTextStyle.s12(color: color.secondary)),
                Text(
                  _subTitle,
                  style: AppTextStyle.s16(
                    fontWeight: FontWeight.w600,
                    color: color.primary,
                  ),
                ),
              ],
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Center(
                child: SizedBox(width: 40, height: 40, child: AppBackButton()),
              ),
            ),
            actions: [_buildStatusChip(context)],
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24).copyWith(top: 4),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 20,
                          children: [
                            _buildReportTitle(context),
                            _buildDivider(Theme.of(context).colorScheme),
                            _buildDescription(),
                            _buildEvidecences(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    ReportStatus status = switch (widget.type) {
      ReportResultFormType.fieldCheck => ReportStatus.fieldCheck,
      ReportResultFormType.action => ReportStatus.action,
    };

    return CustomChip(
      backgroundColor: status
          .getColor(context)
          .containerColor
          .withValues(alpha: 0.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: status.getColor(context).mainColor,
          ),
          Text(
            status.label,
            style: AppTextStyle.s12(
              fontWeight: FontWeight.w500,
              color: status.getColor(context).mainColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTitle(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 8,
        children: [
          Icon(Icons.description_rounded, size: 20, color: color.onPrimary),
          Text(
            widget.reportTitle,
            style: AppTextStyle.s14(
              fontWeight: FontWeight.w600,
              color: color.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ColorScheme color) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        color: color.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(switch (widget.type) {
          ReportResultFormType.fieldCheck => "Deskripsikan Hasil Inspeksi",
          ReportResultFormType.action => "Deskripsikan Hasil Tindakan",
        }, style: AppTextStyle.s14(fontWeight: FontWeight.w600)),
        AppTextField(
          controller: _descriptionController,
          hintText:
              "Contoh: Beberapa bagian jalan mengalami retakan dan lubang yang cukup dalam, mengganggu kelancaran lalu lintas.",
          minLines: 3,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          validator: (value) => InputValidator.empty(value),
        ),
      ],
    );
  }

  Widget _buildEvidecences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          "Bukti Lapangan",
          style: AppTextStyle.s14(fontWeight: FontWeight.w600),
        ),
        EvidencesPicker.fieldOfficer(
          onEvidencesChanged: (files) => _evidences = files,
          initialEvidences: _evidences,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24).copyWith(top: 16),
      child: BlocBuilder<ReportResultFormBloc, ReportResultFormState>(
        builder: (context, state) {
          if (state.isLoading) return AppFilledButton.loading();

          return AppFilledButton(
            onPressed: () => _onSubmit(context),
            text: switch (widget.type) {
              ReportResultFormType.fieldCheck => "Kirimkan Hasil Inspeksi",
              ReportResultFormType.action => "Kirimkan Laporan Akhir",
            },
          );
        },
      ),
    );
  }
}
