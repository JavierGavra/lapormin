import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class AdminSliverAppBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final String title;

  const AdminSliverAppBar({
    super.key,
    required this.onBackTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: false,
      floating: true,
      snap: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: const Color(0x40000000),
      elevation: 5,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        width: double.infinity,
        height: 102,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 24, top: 50, right: 12, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 4,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                GestureDetector(
                  onTap: onBackTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: color.surfaceContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: color.onSurface,
                      size: 20,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyle.s16(
                    color: color.primary,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
