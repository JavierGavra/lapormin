import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 27),
      decoration: ShapeDecoration(
        color: color.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context: context,
            index: 0,
            iconFilled: Icons.home,
            iconOutlined: Icons.home_outlined,
            label: "BERANDA",
            isSelected: currentIndex == 0,
          ),
          _buildNavItem(
            context: context,
            index: 1,
            iconFilled: Icons.description,
            iconOutlined: Icons.description_outlined,
            label: "LAPORAN",
            isSelected: currentIndex == 1,
          ),
          _buildNavItem(
            context: context,
            index: 2,
            iconFilled: Icons.engineering,
            iconOutlined: Icons.engineering_outlined,
            label: "PETUGAS",
            isSelected: currentIndex == 2,
          ),
          _buildNavItem(
            context: context,
            index: 3,
            iconFilled: Icons.map,
            iconOutlined: Icons.map_outlined,
            label: "PETA",
            isSelected: currentIndex == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData iconFilled,
    required IconData iconOutlined,
    required String label,
    required bool isSelected,
  }) {
    final color = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: ShapeDecoration(
            color: isSelected ? color.secondaryContainer : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? iconFilled : iconOutlined,
                size: 24,
                color: isSelected
                    ? color.onSecondaryContainer
                    : color.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyle.s11(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? color.onSecondaryContainer
                      : color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
