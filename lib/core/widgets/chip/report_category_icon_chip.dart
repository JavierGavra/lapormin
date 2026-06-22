import 'package:flutter/material.dart';

import '../../constants/report_category_enum.dart';

class ReportCategoryIconChip extends StatelessWidget {
  final ReportCategory category;

  const ReportCategoryIconChip(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: category.getColor(context).containerColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        category.icon,
        size: 18,
        color: category.getColor(context).onContainerColor,
      ),
    );
  }
}
