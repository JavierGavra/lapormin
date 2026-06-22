import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/constant.dart';
import '../../../../../../core/utils/text_style/app_text_style.dart';
import 'evidences_preview_item.dart';

class EvidencesPreview extends StatelessWidget {
  final List<String> evidences;
  final bool isMaxSizeReached;
  final void Function(int index) onRemove;

  const EvidencesPreview({
    super.key,
    required this.evidences,
    required this.isMaxSizeReached,
    required this.onRemove,
  });

  static const int _crossAxisCount = 3;
  static const double _gap = 8;

  String get _totalSizeMB {
    final bytes = evidences.fold(
      0,
      (sum, filePath) => sum + File(filePath).lengthSync(),
    );
    return (bytes / (1024 * 1024)).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: const Radius.circular(12),
        padding: EdgeInsets.zero,
        color: color.outline,
        dashPattern: const [5, 5],
        strokeWidth: 1.5,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            _buildHeader(color),
            evidences.isEmpty ? _buildEmptyState(color) : _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Terpilih : ${evidences.length}/${Constant.evidencesMaxFiles}",
          style: AppTextStyle.s14(
            color: color.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "$_totalSizeMB MB / 50 MB",
          style: AppTextStyle.s11(
            color: isMaxSizeReached ? color.error : color.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme color) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "Belum ada bukti ditambahkan.",
          style: AppTextStyle.s14(color: color.onSurfaceVariant),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (_gap * (_crossAxisCount - 1))) /
            _crossAxisCount;

        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: List.generate(
            evidences.length,
            (index) => EvidencesPreviewItem(
              filePath: evidences[index],
              size: itemWidth,
              onRemove: () => onRemove(index),
            ),
          ),
        );
      },
    );
  }
}
