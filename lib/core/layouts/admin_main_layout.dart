import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/admin_buttom_nav/admin_bottom_nav.dart';
import 'package:lapormin/features/home/presentation/pages/admin/home_admin_page.dart';

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeAdminPage(),
    const Center(child: Text("Halaman Laporan (Admin)")),
    const Center(child: Text("Halaman Petugas (Admin)")),
    const Center(child: Text("Halaman Peta (Admin)")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
