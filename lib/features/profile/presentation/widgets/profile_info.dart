import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lapormin/core/utils/phone_number/phone_number_format.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';
import 'package:lapormin/core/widgets/snackbar/custom_snackbar.dart';

class ProfileInfo extends StatelessWidget {
  final String phoneNumber;
  final int reportAmount;
  final DateTime createdAt;

  const ProfileInfo({
    super.key,
    required this.phoneNumber,
    required this.reportAmount,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Column(
      spacing: 8,
      children: [
        _buildPhoneNumber(context),
        Row(
          spacing: 8,
          children: [
            Expanded(
              flex: 5,
              child: _buildAdditionalInfo(
                color: color,
                contentColor: color.secondary,
                icon: Icons.edit_calendar_outlined,
                label: "Bergabung",
                value: createdAt,
              ),
            ),
            Expanded(
              flex: 4,
              child: _buildAdditionalInfo(
                color: color,
                contentColor: color.tertiary,
                icon: Icons.assignment_outlined,
                label: "Laporan",
                value: reportAmount,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onLongPress: () => _copyPhoneNumber(context, color),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Text(
                  "Nomor Telepon",
                  style: AppTextStyle.s12(color: color.surfaceContainerHighest),
                ),
                Text(
                  PhoneNumberFormat.formatted(phoneNumber),
                  style: AppTextStyle.s14(
                    fontWeight: FontWeight.w600,
                    color: color.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _copyPhoneNumber(BuildContext context, ColorScheme color) {
    // HapticFeedback.lightImpact();
    Clipboard.setData(
      ClipboardData(text: PhoneNumberFormat.formatted(phoneNumber)),
    );
    showSnackBar(context, "Nomor telepon disalin!");
  }

  Widget _buildAdditionalInfo({
    required ColorScheme color,
    required Color contentColor,
    required IconData icon,
    required String label,
    required dynamic value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.outline),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color.onSecondary, size: 20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyle.s12(color: color.onSurfaceVariant),
                ),
                Text(
                  (value is DateTime)
                      ? DateFormat('dd MMM yyyy', 'id_ID').format(value)
                      : "$value",
                  style: AppTextStyle.s14(
                    fontWeight: FontWeight.w600,
                    color: contentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
