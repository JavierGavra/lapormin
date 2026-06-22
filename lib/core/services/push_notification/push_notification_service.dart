import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lapormin/core/database/local_data_persistance.dart';
import 'package:lapormin/firebase_options.dart';
import 'package:lapormin/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Letakkan di luar class!
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 1. Wajib init Firebase di isolate background
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('has_unread_notification', true);

  debugPrint("Notifikasi Background Diterima: ${message.messageId}");
}

String _resolveChannelId(String tipeNotif) {
  return switch (tipeNotif) {
    'ganti_status' ||
    'penugasan' ||
    'hasil_lapangan' => 'status_laporan_channel',
    _ => 'general_channel',
  };
}

String _resolveChannelName(String tipeNotif) {
  return switch (tipeNotif) {
    'ganti_status' ||
    'penugasan' ||
    'hasil_lapangan' => 'Pembaruan Status Laporan',
    _ => 'Pemberitahuan Umum',
  };
}

final ValueNotifier<bool> unreadBadgeNotifier = ValueNotifier<bool>(false);

class PushNotificationService {
  final _localNotifPlugin = FlutterLocalNotificationsPlugin();
  final messaging = FirebaseMessaging.instance;

  Future setupMachine() async {
    const initSettingsAndroid = AndroidInitializationSettings(
      'ic_notification',
    );

    const initSettingsIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIos,
    );

    await _localNotifPlugin.initialize(settings: initializationSettings);

    const AndroidNotificationChannel channel1 = AndroidNotificationChannel(
      'status_laporan_channel',
      'Pembaruan Status Laporan',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    const AndroidNotificationChannel channel2 = AndroidNotificationChannel(
      'general_channel',
      'Pemberitahuan Umum',
      importance: Importance.defaultImportance,
      playSound: true,
      enableVibration: true,
    );

    final androidImplementation = _localNotifPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(channel1);
      await androidImplementation.createNotificationChannel(channel2);
    }
  }

  Future<String?> requestPermission() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        debugPrint('FCM Token didapatkan: $token');
        return token;
      }

      return null;
    } catch (e) {
      debugPrint('Error saat meminta izin notifikasi: $e');
      return null;
    }
  }

  void listenToMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Notifikasi Foreground Diterima!');

      if (message.notification != null) {
        debugPrint('Judul: ${message.notification?.title}');
        await sl<LocalDataPersistance>().setHasUnreadNotification(true);
        unreadBadgeNotifier.value = true;
        _showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('User menekan notifikasi: ${message.notification?.title}');
    });
  }

  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    // Gunakan helper top-level agar konsisten dengan background handler
    final tipeNotif = message.data['tipe_notif'] ?? 'general';
    final channelId = _resolveChannelId(tipeNotif);
    final channelName = _resolveChannelName(tipeNotif);

    _localNotifPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: 'Notifikasi dari LaporMin!',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_notification',
        ),
      ),
      payload: message.data.toString(),
    );
  }
}
