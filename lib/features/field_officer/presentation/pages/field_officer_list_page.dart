import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/widgets/sliver_app_bar/sliver_app_bar.dart';
import 'package:lapormin/features/field_officer/presentation/widgets/bottom_sheet/field_officer_bottom_sheet.dart';
import 'package:lapormin/features/field_officer/presentation/widgets/custom_add_fab.dart';
import 'package:lapormin/features/field_officer/presentation/widgets/field_officer_card.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/field_officer/field_officer_bloc.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/field_officer/field_officer_event.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/field_officer/field_officer_state.dart';
import 'package:lapormin/features/field_officer/presentation/widgets/field_officer_card_shimmer.dart';
import 'package:lapormin/features/field_officer/presentation/pages/add_field_officer_page.dart';
import 'package:lapormin/injection.dart';
import 'package:lapormin/features/field_officer/presentation/bloc/add_field_officer/add_field_officer_bloc.dart';

class FieldOfficerListPage extends StatefulWidget {
  const FieldOfficerListPage({super.key});

  @override
  State<FieldOfficerListPage> createState() => _FieldOfficerListPageState();
}

class _FieldOfficerListPageState extends State<FieldOfficerListPage> {
  @override
  void initState() {
    super.initState();
    _fetchOfficers();
  }

  void _fetchOfficers() {
    context.read<FieldOfficerBloc>().add(const FetchFieldOfficers());
  }

  Future<void> _onRefresh() async {
    _fetchOfficers();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
        child: CustomAddFab(
          onTap: () {
            debugPrint("Tombol Tambah Petugas Diklik!");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => sl<AddFieldOfficerBloc>(),
                  child: const AddFieldOfficerPage(),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: RefreshIndicator(
          color: color.primary,
          backgroundColor: color.surfaceContainerHighest,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              AppSliverAppBar(
                title: "Petugas Lapangan",
                onNotificationTap: () {
                  debugPrint("Buka notifikasi");
                },
              ),

              BlocBuilder<FieldOfficerBloc, FieldOfficerState>(
                builder: (context, state) {
                  if (state.status == FieldOfficerStatus.loading ||
                      state.status == FieldOfficerStatus.initial) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      sliver: SliverList.separated(
                        itemCount: 6,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            const FieldOfficerCardShimmer(),
                      ),
                    );
                  }

                  if (state.status == FieldOfficerStatus.failure) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          state.errorMessage ?? "Gagal memuat data petugas.",
                          style: TextStyle(color: color.error),
                        ),
                      ),
                    );
                  }

                  if (state.officers.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "Belum ada petugas lapangan yang terdaftar.",
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    sliver: SliverList.separated(
                      itemCount: state.officers.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final officer = state.officers[index];

                        return FieldOfficerCard(
                          initial: officer.initial,
                          name: officer.name,
                          phone: officer.phone,
                          onTap: () {
                            FieldOfficerBottomSheet.show(context, officer);
                          },
                        );
                      },
                    ),
                  );
                },
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ),
    );
  }
}
