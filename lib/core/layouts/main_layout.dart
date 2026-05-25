import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/bottom_nav/bottom_nav.dart';
import 'package:lapormin/features/home/presentation/pages/informant/home_page.dart';
import 'package:lapormin/features/report/presentation/pages/report_list_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _pages => [
    HomePage(onSeeAllTapped: () => _changeTab(1)),
    const ReportListPage(),
    const Center(child: Text("Halaman Peta (Segera)")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNav(
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
