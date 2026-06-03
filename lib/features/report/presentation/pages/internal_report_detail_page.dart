import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/widgets/loading/fullscreen_loading_overlay.dart';

import '../../../../injection.dart';
import '../../../../core/constants/user_role_enum.dart';
import '../../../../core/utils/text_style/app_text_style.dart';
import '../../../../core/widgets/button/app_back_button.dart';
import '../../../../core/widgets/button/app_icon_button.dart';
import '../../../../core/widgets/snackbar/custom_snackbar.dart';
import '../bloc/internal_report_detail/internal_report_detail_bloc.dart';
import '../widgets/report_detail/information/report_info_tab.dart';
import '../widgets/report_detail/status/informant/informant_report_status_tab.dart';
import '../widgets/report_detail/status/admin/admin_report_status_tab.dart';
import '../widgets/report_detail/status/field_officer/field_officer_report_status_tab.dart';

class InternalReportDetailPage extends StatefulWidget {
  final String id;
  final UserRole role;

  const InternalReportDetailPage({
    super.key,
    required this.role,
    required this.id,
  });

  @override
  State<InternalReportDetailPage> createState() =>
      _InternalReportDetailPageState();
}

class _InternalReportDetailPageState extends State<InternalReportDetailPage> {
  bool _isOverlayLoadingOpen = false;

  void _listener(BuildContext context, InternalReportDetailState state) {
    if (state.isOverlayLoading) {
      FullscreenLoadingOverlay.show(context);
      _isOverlayLoadingOpen = true;
    }

    if (!state.isOverlayLoading && _isOverlayLoadingOpen) {
      FullscreenLoadingOverlay.hide(context);
      _isOverlayLoadingOpen = false;
    }

    if (state.status == InternalReportDetailStatus.failure) {
      showSnackBar(
        context,
        state.errorMessage ?? "Terjadi kesalahan",
        type: SnackBarType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return sl<InternalReportDetailBloc>()
          ..add(InternalReportDetailOpened(widget.id));
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body:
              BlocListener<InternalReportDetailBloc, InternalReportDetailState>(
                listener: _listener,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    _buildAppBar(context, innerBoxIsScrolled),
                  ],
                  body: _buildTabBarView(),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool innerBoxIsScrolled) {
    final color = Theme.of(context).colorScheme;
    return SliverAppBar(
      pinned: true,
      floating: true,
      centerTitle: true,
      titleSpacing: 16,
      leadingWidth: 24 + 40, // (Padding kiri) + (Lebar tombol)
      scrolledUnderElevation: 0,
      forceElevated: innerBoxIsScrolled,
      backgroundColor: color.surfaceContainerLowest,
      actionsPadding: const EdgeInsets.only(right: 24),
      title: Text(
        "Detail Laporan",
        style: AppTextStyle.s16(fontWeight: FontWeight.w600),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Center(
          child: SizedBox(width: 40, height: 40, child: AppBackButton()),
        ),
      ),
      actions: (widget.role == UserRole.informant)
          ? [
              AppIconButton(
                icon: Icons.more_vert_rounded,
                onPressed: () => showSnackBar(
                  context,
                  "Fitur belum tersedia",
                  type: SnackBarType.failure,
                ),
              ),
            ]
          : null,
      bottom: TabBar(
        labelStyle: AppTextStyle.s14(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyle.s14(fontWeight: FontWeight.w500),
        labelColor: color.primary,
        unselectedLabelColor: color.onSurfaceVariant,
        indicatorColor: color.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: "Informasi"),
          Tab(text: "Status"),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    final statusTab = switch (widget.role) {
      UserRole.informant => InformantReportStatusTab(),
      UserRole.admin => AdminReportStatusTab(id: widget.id),
      UserRole.fieldOfficer => FieldOfficerReportStatusTab(),
    };

    return TabBarView(
      children: [
        ReportInfoTab(id: widget.id),
        statusTab,
      ],
    );
  }
}
