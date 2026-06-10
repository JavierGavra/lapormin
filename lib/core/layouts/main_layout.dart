import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/features/notification/presentation/widgets/dialog/ask_notification_dialog.dart';
import 'package:lapormin/injection.dart';
import 'package:lapormin/core/widgets/bottom_nav/bottom_nav.dart';
import 'package:lapormin/features/home/presentation/pages/informant/home_page.dart';
import 'package:lapormin/features/map/presentation/pages/map_page.dart';
import 'package:lapormin/features/report/presentation/pages/report_list_page.dart';
import 'package:lapormin/features/map/presentation/bloc/map_bloc.dart';
import 'package:lapormin/features/location/presentation/bloc/location_picker/location_picker_bloc.dart';

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

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<MapBloc>()),
        BlocProvider(create: (_) => sl<LocationPickerBloc>()),
      ],
      child: const MapPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    AskNotificationDialog.show(context);
  }

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
