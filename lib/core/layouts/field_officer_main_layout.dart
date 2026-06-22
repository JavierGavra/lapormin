import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/bottom_nav/field_officer_buttom_nav.dart';
import 'package:lapormin/features/home/presentation/pages/field_officer/home_field_officer_page.dart';
import 'package:lapormin/features/notification/presentation/widgets/dialog/ask_notification_dialog.dart';
import 'package:lapormin/features/profile/presentation/pages/profile_page.dart';
import 'package:lapormin/features/report/presentation/pages/field_officer_report_listt_page.dart';

class FieldOfficerMainLayout extends StatefulWidget {
  const FieldOfficerMainLayout({super.key});
  @override
  State<FieldOfficerMainLayout> createState() => _FieldOfficerMainLayoutState();
}

class _FieldOfficerMainLayoutState extends State<FieldOfficerMainLayout> {
  int _currentIndex = 0;

  void _onNavigateToReports() {
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    AskNotificationDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeFieldOfficerPage(onNavigateToReports: _onNavigateToReports),
      const FieldOfficerReportListPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: FieldOfficerBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
