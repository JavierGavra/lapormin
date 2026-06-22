import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class AppMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const AppMenuItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });
}

class AppPopupMenuButton extends StatelessWidget {
  final List<AppMenuItem> items;
  final IconData icon;
  final Color? backgroundColor;

  const AppPopupMenuButton({
    super.key,
    required this.items,
    this.icon = Icons.more_vert_rounded,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return MenuAnchor(
      style: MenuStyle(
        // elevation: const WidgetStatePropertyAll(2),
        backgroundColor: WidgetStatePropertyAll(color.surfaceContainer),
        // shape: WidgetStatePropertyAll(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //     side: BorderSide(color: color.outlineVariant),
        //   ),
        // ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      menuChildren: items.map((item) => _buildMenuItem(context, item)).toList(),
      builder: (context, controller, _) {
        return IconButton(
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          icon: Icon(icon),
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
              EdgeInsets.zero,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: WidgetStatePropertyAll<Color>(
              backgroundColor ?? color.surfaceContainer,
            ),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            iconSize: const WidgetStatePropertyAll<double>(20),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, AppMenuItem item) {
    final color = Theme.of(context).colorScheme;
    final itemColor = item.color ?? color.onSurface;

    return MenuItemButton(
      onPressed: item.onTap,
      leadingIcon: Icon(
        item.icon,
        size: 20,
        color: item.onTap != null
            ? itemColor
            : itemColor.withValues(alpha: 0.38),
      ),
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
      ),
      child: Text(
        item.label,
        style: AppTextStyle.s14(
          color: item.onTap != null
              ? itemColor
              : itemColor.withValues(alpha: 0.38),
        ),
      ),
    );
  }
}
