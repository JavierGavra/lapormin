import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/text_style/app_text_style.dart';
import 'app_chip.dart';

class DueActionChip extends StatelessWidget {
  final DateTime? dueAction;

  const DueActionChip(this.dueAction, {super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return AppChip(
      vertical: 4,
      backgroundColor: color.error,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(Icons.calendar_month_outlined, size: 16, color: color.onError),
          Text(
            "Tenggat : ${dueAction != null ? DateFormat('dd MMMM yyyy', 'id_ID').format(dueAction!) : "Tidak ada batas waktu"}",
            style: AppTextStyle.s12(color: color.onError),
          ),
        ],
      ),
    );
  }
}
