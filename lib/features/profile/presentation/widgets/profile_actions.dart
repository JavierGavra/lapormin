import 'package:flutter/material.dart';
import 'package:lapormin/core/utils/text_style/app_text_style.dart';

class ProfileActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class ProfileActions extends StatelessWidget {
  final List<ProfileActionItem> items;

  const ProfileActions({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias, // agar InkWell splash tidak keluar border
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final isFirst = index == 0;
          final isLast = index == items.length - 1;
          final borderRadius = BorderRadius.vertical(
            top: Radius.circular(isFirst ? 16 : 0),
            bottom: Radius.circular(isLast ? 16 : 0),
          );

          return Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: _buildActionTile(context, items[index], isLast: isLast),
          );
        }),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    ProfileActionItem item, {
    required bool isLast,
  }) {
    final color = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: item.onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 40,
                  child: Icon(item.icon, color: color.onSurface),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyle.s14(
                      fontWeight: FontWeight.w500,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color.onSurface),
              ],
            ),
          ),
        ),

        // Divider hanya antar item, tidak setelah item terakhir
        if (!isLast)
          Divider(height: 1, thickness: 1, color: color.outlineVariant),
      ],
    );
  }
}
