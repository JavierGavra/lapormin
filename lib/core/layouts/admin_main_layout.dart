import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/injection.dart';
import 'package:lapormin/core/widgets/bottom_nav/admin_bottom_nav.dart';
import 'package:lapormin/features/home/presentation/pages/admin/home_admin_page.dart';
import 'package:lapormin/features/report/presentation/pages/admin_report_list_page.dart';
import 'package:lapormin/features/map/presentation/pages/map_page.dart';
import 'package:lapormin/features/map/presentation/bloc/map_bloc.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';

class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => _AdminMainLayoutState();
}

class _AdminMainLayoutState extends State<AdminMainLayout> {
  int _currentIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _pages => [
    HomeAdminPage(
      onSeeAllTapped: () {
        _changeTab(1);
      },
    ),
    const AdminReportListPage(),
    const Center(child: Text("Halaman Petugas (Admin)")),

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MapBloc>()),
        BlocProvider(create: (_) => sl<LocationPickerBloc>()),
      ],
      child: const MapPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _currentIndex,
        onTap: _changeTab,
      ),
    );
  }
}
