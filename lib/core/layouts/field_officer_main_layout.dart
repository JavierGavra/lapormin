import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/field_officer_buttom_nav/field_officer_buttom_nav.dart';
import 'package:lapormin/features/home/presentation/pages/field_officer/home_field_officer_page.dart';

class FieldOfficerMainLayout extends StatefulWidget {
  const FieldOfficerMainLayout({super.key});
  @override
  State<FieldOfficerMainLayout> createState() => _FieldOfficerMainLayoutState();
}

class _FieldOfficerMainLayoutState extends State<FieldOfficerMainLayout> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeFieldOfficerPage(),
    const Center(child: Text("Halaman Laporan (Petugas)")),
    const Center(child: Text("Halaman Profil (Petugas)")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: FieldOfficerBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
