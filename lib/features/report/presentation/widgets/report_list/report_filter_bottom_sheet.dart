import 'package:flutter/material.dart';
import 'package:lapormin/core/constants/report_category_enum.dart';
import 'package:lapormin/core/constants/report_status_enum.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/features/report/domain/params/report_filter_params.dart';

class ReportFilterBottomSheet extends StatefulWidget {
  final ReportFilterParams currentFilter;
  final List<ReportStatus> allowedStatuses;
  final bool hideCategory;
  final bool hideStatus;

  const ReportFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.allowedStatuses,
    this.hideCategory = false,
    this.hideStatus = false,
  });

  @override
  State<ReportFilterBottomSheet> createState() =>
      _ReportFilterBottomSheetState();
}

class _ReportFilterBottomSheetState extends State<ReportFilterBottomSheet> {
  late List<ReportCategory> _tempCategories;
  late List<ReportStatus> _tempStatuses;

  @override
  void initState() {
    super.initState();
    _tempCategories = List.from(widget.currentFilter.categories);
    _tempStatuses = List.from(widget.currentFilter.statuses);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: color.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Filter Penelusuran',
            style: AppTextStyle.s20(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),

          if (!widget.hideCategory) ...[
            Text(
              'Kategori',
              style: AppTextStyle.s14(
                fontWeight: FontWeight.w600,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReportCategory.values.map((cat) {
                final isSelected = _tempCategories.contains(cat);
                final catColor = cat.getColor(context);

                return FilterChip(
                  label: Text(cat.label),
                  selected: isSelected,
                  selectedColor: catColor.containerColor,
                  checkmarkColor: catColor.onContainerColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? catColor.onContainerColor
                        : catColor.mainColor,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : catColor.mainColor,
                    ),
                  ),
                  showCheckmark: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _tempCategories.add(cat);
                      } else {
                        _tempCategories.remove(cat);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          if (!widget.hideStatus) ...[
            Text(
              'Status Laporan',
              style: AppTextStyle.s14(
                fontWeight: FontWeight.w600,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.allowedStatuses.map((stat) {
                final isSelected = _tempStatuses.contains(stat);
                final statColor = stat.getColor(context);

                return FilterChip(
                  label: Text(stat.label),
                  selected: isSelected,
                  selectedColor: statColor.containerColor,
                  checkmarkColor: statColor.mainColor,
                  labelStyle: TextStyle(
                    color: statColor.mainColor,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.transparent
                          : statColor.mainColor,
                    ),
                  ),
                  showCheckmark: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _tempStatuses.add(stat);
                      } else {
                        _tempStatuses.remove(stat);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],

          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Batal',
                    style: AppTextStyle.s16(
                      fontWeight: FontWeight.w600,
                      color: color.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: color.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    final newFilter = ReportFilterParams(
                      keyword: widget.currentFilter.keyword,
                      categories: _tempCategories,
                      statuses: _tempStatuses,
                    );
                    Navigator.pop(context, newFilter);
                  },
                  child: Text(
                    'Terapkan',
                    style: AppTextStyle.s16(
                      fontWeight: FontWeight.w600,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
