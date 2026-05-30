import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/utils/validator/input_validator.dart';
import 'package:lapormin/core/widgets/text_field/app_text_field.dart';
import 'package:lapormin/features/report/presentation/bloc/create_report/create_report_bloc.dart';
import 'package:lapormin/features/report/presentation/widgets/create_report/create_report_step_header.dart';

class _SummaryData {
  final String category;
  final String title;
  final String address;
  final int evidenceAmount;

  const _SummaryData(
    this.category,
    this.title,
    this.address,
    this.evidenceAmount,
  );
}

class SummaryDescriptionStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController descriptionController;

  const SummaryDescriptionStep({
    super.key,
    required this.formKey,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          const CreateReportStepHeader(
            title: "Deskripsikan & kirim",
            description: "Deskripsikan apa yang anda lihat.",
          ),
          _buildSummaryCard(color),
          _buildDescriptionSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ColorScheme color) {
    return BlocSelector<CreateReportBloc, CreateReportState, _SummaryData>(
      selector: (state) => _SummaryData(
        state.category?.label ?? '-',
        state.title ?? '-',
        state.address ?? '-',
        state.evidences.length,
      ),
      builder: (context, data) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                "Ringkasan Laporan",
                style: AppTextStyle.s16(
                  fontWeight: FontWeight.w700,
                  color: color.primary,
                ),
              ),
              _buildSummaryItem(
                color,
                icon: Icons.category_outlined,
                title: "Kategori",
                value: data.category,
              ),
              _buildSummaryItem(
                color,
                icon: Icons.title_rounded,
                title: "Judul",
                value: data.title,
              ),
              _buildSummaryItem(
                color,
                icon: Icons.location_on_outlined,
                title: "Lokasi",
                value: data.address,
              ),
              _buildSummaryItem(
                color,
                icon: Icons.video_collection_outlined,
                title: "Jumlah Bukti",
                value: "${data.evidenceAmount}",
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    ColorScheme color, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, color: color.primary),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyle.s12(
                  fontWeight: FontWeight.w500,
                  color: color.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppTextStyle.s13(
                  fontWeight: FontWeight.w600,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: [
        Text(
          "Deskripsi",
          style: AppTextStyle.s24(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        Form(
          key: formKey,
          child: AppTextField(
            controller: descriptionController,
            hintText:
                "Contoh: Beberapa bagian jalan mengalami retakan dan lubang yang cukup dalam, mengganggu kelancaran lalu lintas.",
            minLines: 3,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            validator: (value) => InputValidator.empty(value),
          ),
        ),
      ],
    );
  }
}
