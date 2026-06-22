import 'package:flutter/material.dart';

import '../../../../../core/constants/report_category_enum.dart';
import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../core/utils/validator/input_validator.dart';
import '../../../../../core/widgets/text_field/app_text_field.dart';
import 'category_picker_widget.dart';

class TitleCategoryStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final ReportCategory initialCategory;
  final ValueChanged<ReportCategory> onCategoryChanged;

  const TitleCategoryStep({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.onCategoryChanged,
    required this.initialCategory,
  });

  @override
  State<TitleCategoryStep> createState() => _TitleCategoryStepState();
}

class _TitleCategoryStepState extends State<TitleCategoryStep>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final color = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Apa yang anda laporkan?",
              style: AppTextStyle.s24(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pilih kategori yang paling sesuai.",
              style: AppTextStyle.s14(color: color.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            CategoryPickerWidget(
              initialCategory: widget.initialCategory,
              onChanged: (value) => widget.onCategoryChanged(value),
            ),
            const SizedBox(height: 40),
            Text(
              "Judul Laporan",
              style: AppTextStyle.s24(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: widget.formKey,
              child: AppTextField(
                controller: widget.titleController,
                hintText: "Mau laporin apa...",
                textCapitalization: TextCapitalization.words,
                validator: (value) => InputValidator.empty(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
