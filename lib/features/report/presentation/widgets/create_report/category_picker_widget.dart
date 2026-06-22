import 'package:flutter/material.dart';

import '../../../../../core/constants/report_category_enum.dart';
import '../../../../../core/utils/text_style/app_text_style.dart';

class CategoryPickerWidget extends StatefulWidget {
  final ReportCategory initialCategory;
  final ValueChanged<ReportCategory> onChanged;

  const CategoryPickerWidget({
    super.key,
    required this.onChanged,
    required this.initialCategory,
  });

  @override
  State<CategoryPickerWidget> createState() => _CategoryPickerWidgetState();
}

class _CategoryPickerWidgetState extends State<CategoryPickerWidget> {
  late ReportCategory selectedCategory;

  static const _categories = [
    ReportCategory.infrastructure,
    ReportCategory.disaster,
    ReportCategory.crime,
    ReportCategory.publicService,
  ];

  void _onTap(ReportCategory category) {
    if (selectedCategory == category) return;
    setState(() => selectedCategory = category);
    widget.onChanged(category);
  }

  @override
  initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        Row(
          spacing: 12,
          children: [
            _buildCard(context, index: 0, category: _categories[0]),
            _buildCard(context, index: 1, category: _categories[1]),
          ],
        ),
        Row(
          spacing: 12,
          children: [
            _buildCard(context, index: 2, category: _categories[2]),
            _buildCard(context, index: 3, category: _categories[3]),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required int index,
    required ReportCategory category,
  }) {
    final color = Theme.of(context).colorScheme;
    final categoryColors = category.getColor(context);
    final isSelected = selectedCategory == category;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 130),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? categoryColors.mainColor
                : categoryColors.containerColor.withValues(alpha: 0.6),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onTap(category),
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category.icon,
                        size: 24,
                        color: categoryColors.mainColor,
                      ),
                    ),
                    Text(
                      category.label,
                      style: AppTextStyle.s14(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? categoryColors.onMainColor
                            : categoryColors.onContainerColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
