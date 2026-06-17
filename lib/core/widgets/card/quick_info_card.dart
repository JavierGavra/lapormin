import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class AdminQuickInfoCard extends StatelessWidget {
  final String title;
  final String count;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color titleColor;
  final IconData iconData;
  final bool isLargeText;

  const AdminQuickInfoCard({
    super.key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.titleColor,
    required this.iconData,
    this.isLargeText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: const Color(0x40000000),
      borderRadius: BorderRadius.circular(16),
      color: backgroundColor,
      child: Container(
        height: 128,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: ShapeDecoration(
                color: iconBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Icon(iconData, size: 16, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: AppTextStyle.s24(
                fontWeight: FontWeight.w800,
                fontFamily: 'DM Sans',
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyle.s13(
                fontWeight: FontWeight.w500,
                fontFamily: 'DM Sans',
                color: titleColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
