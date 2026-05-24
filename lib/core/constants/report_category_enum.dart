import 'package:flutter/material.dart';
import 'package:lapormin/core/theme/theme.dart';

enum ReportCategory {
  crime('crime', 'Kriminal', Icons.warning_amber_rounded),
  disaster('disaster', 'Bencana', Icons.flood_outlined),
  infrastructure('infrastructure', 'Infrastruktur', Icons.apartment_outlined),
  publicService(
    'public_service',
    'Layanan Publik',
    Icons.account_balance_outlined,
  );

  final String dbValue;
  final String label;
  final IconData icon;

  const ReportCategory(this.dbValue, this.label, this.icon);

  // Fungsi pengelompokan warna (Hanya panggil Theme 1 kali!)
  CategoryColors getColor(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return switch (this) {
      crime => CategoryColors(
        mainColor: color.error,
        onMainColor: color.onError,
        containerColor: color.errorContainer,
        onContainerColor: color.onErrorContainer,
      ),
      disaster => CategoryColors(
        mainColor: color.warning,
        onMainColor: color.onWarning,
        containerColor: color.warningContainer,
        onContainerColor: color.onWarningContainer,
      ),
      infrastructure => CategoryColors(
        mainColor: color.primary,
        onMainColor: color.onPrimary,
        containerColor: color.primaryContainer,
        onContainerColor: color.onPrimaryContainer,
      ),
      publicService => CategoryColors(
        mainColor: color.success,
        onMainColor: color.onSuccess,
        containerColor: color.successContainer,
        onContainerColor: color.onSuccessContainer,
      ),
    };
  }

  static ReportCategory fromString(String status) =>
      ReportCategory.values.firstWhere(
        (e) => e.dbValue == status,
        orElse: () => ReportCategory.publicService,
      );
}

class CategoryColors {
  final Color mainColor;
  final Color onMainColor;
  final Color containerColor;
  final Color onContainerColor;

  const CategoryColors({
    required this.mainColor,
    required this.onMainColor,
    required this.containerColor,
    required this.onContainerColor,
  });
}
