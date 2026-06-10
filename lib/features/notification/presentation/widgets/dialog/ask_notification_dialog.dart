import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/utils/text_style/app_text_style.dart';
import '../../../../../core/widgets/loading/fullscreen_loading_overlay.dart';
import '../../../../../injection.dart';
import '../../bloc/notification_permission/notification_permission_bloc.dart';

class AskNotificationDialog extends StatelessWidget {
  const AskNotificationDialog({super.key});

  static Future<void> show(BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isGranted) return;

    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (context) => const AskNotificationDialog(),
      );
    }
  }

  void _requestPermission(BuildContext context) {
    context.read<NotificationPermissionBloc>().add(
      const NotificationPermissionRequested(),
    );
  }

  void _listener(BuildContext context, NotificationPermissionState state) {
    if (state.isLoading) {
      FullscreenLoadingOverlay.show(context);
    } else if (!state.isLoading ||
        state.status != NotificationPermissionStatus.initial) {
      FullscreenLoadingOverlay.hide(context);

      if (state.status == NotificationPermissionStatus.success) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => sl<NotificationPermissionBloc>(),
      child: BlocConsumer<NotificationPermissionBloc, NotificationPermissionState>(
        listener: _listener,
        builder: (context, state) {
          bool isFailure = state.status == NotificationPermissionStatus.failure;
          String title = 'Notifikasi';
          String message =
              'Aktifkan notifikasi untuk mendapatkan pembaruan terbaru tentang laporan Anda.';

          if (isFailure) {
            title = 'Izin Notifikasi Ditolak';
            message = state.errorMessage ?? "-";
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: size.width * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.s20(
                      color: isFailure ? color.error : color.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    message,
                    style: AppTextStyle.s14(color: color.onSurfaceVariant),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: isFailure
                        ? [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: color.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 40),
                                  textStyle: AppTextStyle.s14(
                                    color: color.primary,
                                  ),
                                ),
                                child: const Text('Tutup'),
                              ),
                            ),
                          ]
                        : [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: color.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 40),
                                  textStyle: AppTextStyle.s14(
                                    color: color.primary,
                                  ),
                                ),
                                child: const Text('Batal'),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _requestPermission(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: color.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: Size(double.infinity, 40),
                                  textStyle: AppTextStyle.s14(
                                    color: color.onPrimary,
                                  ),
                                ),
                                child: const Text('Aktifkan'),
                              ),
                            ),
                          ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
