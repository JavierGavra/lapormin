import 'package:flutter/material.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/features/admin/presentation/widgets/custom_add_fab.dart';
import 'package:lapormin/features/admin/presentation/widgets/field_officer_card.dart';

class FieldOfficerListPage extends StatelessWidget {
  const FieldOfficerListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    //TODO: Ganti data dummy ini dengan data asli dari API
    final List<Map<String, String>> officers = [
      {"initial": "RN", "name": "Rusdi Nasution", "phone": "0858-3317-9045"},
      {"initial": "RV", "name": "Robert Viktor", "phone": "0812-3456-7890"},
      {"initial": "AH", "name": "Ahmad Hambali", "phone": "0821-2345-6789"},
      {"initial": "JB", "name": "Jerome Bell", "phone": "0831-1234-5678"},
      {"initial": "JW", "name": "Jenny Wilson", "phone": "0841-9876-5432"},
    ];

    return Scaffold(
      backgroundColor: color.surface,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: CustomAddFab(
          onTap: () {
            debugPrint("Tombol Tambah Petugas Diklik!");
            // TODO: Buat Navigasi ke Halaman Add Field Officer
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            AppSliverAppBar(
              title: "Petugas Lapangan",
              profileUrl: "assets/images/profiles/profile.png",
              onNotificationTap: () {
                debugPrint("Buka notifikasi");
              },
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverList.separated(
                itemCount: officers.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final data = officers[index];
                  return FieldOfficerCard(
                    initial: data["initial"]!,
                    name: data["name"]!,
                    phone: data["phone"]!,
                    onTap: () {
                      debugPrint("Buka detail petugas: ${data['name']}");
                      // TODO: Navigasi ke detail petugas
                    },
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
