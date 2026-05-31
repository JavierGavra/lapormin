import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/utils/phone_number/phone_number_format.dart';

import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../domain/entities/field_check.dart';

class FieldCheckCard extends StatelessWidget {
  final FieldCheck fieldCheck;

  const FieldCheckCard({super.key, required this.fieldCheck});

  String get _initials {
    final words = fieldCheck.fieldOfficerName.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return words[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          _buildOfficerInfo(color),
          _buildDescription(color),
          _buildEvidences(color),
          _buildFooter(color),
        ],
      ),
    );
  }

  Widget _buildOfficerInfo(ColorScheme color) {
    return Row(
      spacing: 12,
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _initials,
              style: AppTextStyle.s16(
                fontWeight: FontWeight.w600,
                color: color.onPrimary,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Text(
              fieldCheck.fieldOfficerName,
              style: AppTextStyle.s14(
                fontWeight: FontWeight.w600,
                color: color.onPrimaryContainer,
              ),
            ),
            Text(
              PhoneNumberFormat.formatted(fieldCheck.fieldOfficerPhone),
              style: AppTextStyle.s12(color: color.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription(ColorScheme color) {
    return Text(
      fieldCheck.description,
      style: AppTextStyle.s14(color: color.onSurfaceVariant),
    );
  }

  Widget _buildEvidences(ColorScheme color) {
    const int crossAxisCount = 3;
    const double gap = 16;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (gap * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              [
                "assets/images/cards/banjir.png",
                "assets/images/cards/kriminal.png",
              ].map((evidence) {
                return SizedBox(
                  width: itemWidth,
                  height: itemWidth,
                  child: Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(evidence),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        );
      },
    );
  }

  Widget _buildFooter(ColorScheme color) {
    return Row(
      spacing: 4,
      children: [
        Icon(
          Icons.format_quote_outlined,
          size: 16,
          color: color.onPrimaryContainer,
        ),
        Text(
          'Hanya Baca • ${DateFormat('dd MMMM yyyy', 'id_ID').format(fieldCheck.createdAt)}',
          style: AppTextStyle.s12(
            color: color.onPrimaryContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
