import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: color.surface,
      indicatorColor: color.primaryContainer,
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: color.onSurfaceVariant),
          selectedIcon: Icon(Icons.home, color: color.onPrimaryContainer),
          label: 'BERANDA',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined, color: color.onSurfaceVariant),
          selectedIcon: Icon(
            Icons.description,
            color: color.onPrimaryContainer,
          ),
          label: 'LAPORAN',
        ),
        NavigationDestination(
          icon: Icon(Icons.map_outlined, color: color.onSurfaceVariant),
          selectedIcon: Icon(Icons.map, color: color.onPrimaryContainer),
          label: 'PETA',
        ),
      ],
    );
  }
}
