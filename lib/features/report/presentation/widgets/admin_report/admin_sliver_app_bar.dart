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
      shadowColor: color.onSurface,
      elevation: 5,
      leadingWidth: 72,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
        child: GestureDetector(
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
            child: Icon(Icons.arrow_back, color: color.onSurface, size: 20),
          ),
        ),
      ),
      title: Text(
        title,
        style: AppTextStyle.s16(
          color: color.primary,
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
