import 'package:flutter/material.dart';
import 'package:lapormin/features/field_officer/domain/entities/field_officer.dart';
import 'package:lapormin/features/field_officer/presentation/widgets/bottom_sheet/field_officer_bottom_sheet_header.dart';
import 'package:lapormin/features/field_officer/presentation/widgets/bottom_sheet/field_officer_bottom_sheet_info.dart';

class FieldOfficerBottomSheet extends StatelessWidget {
  final FieldOfficer officer;

  const FieldOfficerBottomSheet({super.key, required this.officer});

  static Future<void> show(BuildContext context, FieldOfficer officer) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => FieldOfficerBottomSheet(officer: officer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/backgrounds/bottom_sheet_background.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24).copyWith(top: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 32,
              children: [
                FieldOfficerBottomSheetHeader(
                  username: officer.name,
                  photoProfile: null,
                ),
                FieldOfficerBottomSheetInfo(
                  phoneNumber: officer.phone,
                  reportAmount: officer.reportAmount,
                  createdAt: officer.createdAt,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
