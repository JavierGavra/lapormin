import 'package:flutter/material.dart';

class ReportLayoutSwitch extends StatelessWidget {
  final bool isStyle1;
  final ValueChanged<bool> onSwitch;

  const ReportLayoutSwitch({
    super.key,
    required this.isStyle1,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => onSwitch(true),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: isStyle1 ? color.primary : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: color.primary),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            child: Icon(
              Icons.view_agenda_outlined,
              size: 20,
              color: isStyle1 ? Colors.white : color.primary,
            ),
          ),
        ),

        GestureDetector(
          onTap: () => onSwitch(false),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              color: !isStyle1 ? color.primary : Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: color.primary),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
            child: Icon(
              Icons.table_rows_outlined,
              size: 20,
              color: !isStyle1 ? Colors.white : color.primary,
            ),
          ),
        ),
      ],
    );
  }
}
