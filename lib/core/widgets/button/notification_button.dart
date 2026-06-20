import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lapormin/core/database/local_data_persistance.dart';
import 'package:lapormin/core/route/navigate.dart';
import 'package:lapormin/core/services/push_notification/push_notification_service.dart';
import 'package:lapormin/features/notification/presentation/bloc/notification_history/notification_history_bloc.dart';
import 'package:lapormin/features/notification/presentation/pages/notification_history_page.dart';
import 'package:lapormin/injection.dart';

class NotificationButton extends StatefulWidget {
  const NotificationButton({super.key});

  @override
  State<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncBadgeWithStorage(); // Cek saat widget pertama kali dibuat
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Menangkap momen saat aplikasi kembali dibuka dari background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncBadgeWithStorage();
    }
  }

  Future<void> _syncBadgeWithStorage() async {
    // Membaca status terbaru dari brankas lokal (yang mungkin diubah oleh Isolate Background)
    final hasUnread =
        sl<LocalDataPersistance>().getHasUnreadNotification ?? false;

    // Sinkronkan ke Notifier agar UI ikut berubah
    unreadBadgeNotifier.value = hasUnread;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return ValueListenableBuilder(
      valueListenable: unreadBadgeNotifier,
      builder: (context, value, child) {
        return IconButton(
          onPressed: () async {
            unreadBadgeNotifier.value = false;
            await sl<LocalDataPersistance>().setHasUnreadNotification(false);

            if (!context.mounted) return;

            await Navigate.push(context, const NotificationHistoryPage());

            if (context.mounted) {
              context.read<NotificationHistoryBloc>().add(
                NotificationHistoryReadAll(),
              );
              context.read<NotificationHistoryBloc>().add(
                NotificationHistoryOpened(),
              );
            }
          },
          icon: Stack(
            children: [
              Icon(Icons.notifications_none_rounded, color: color.onSurface),
              if (value)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: color.tertiary,
                      shape: BoxShape.circle,
                    ),
                    // Jika Anda ingin menampilkan angka, ganti dengan Text()
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
