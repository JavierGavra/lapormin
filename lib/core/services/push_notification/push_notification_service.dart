import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Letakkan di luar class!
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Notifikasi Background Diterima: ${message.messageId}");
  debugPrint("Isi Data: ${message.data}");
}

class PushNotificationService {
  final _localNotifPlugin = FlutterLocalNotificationsPlugin();
  final messaging = FirebaseMessaging.instance;

  Future setupMachine() async {
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
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
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error saat meminta izin notifikasi: $e');
      return null;
    }
  }

  void listenToMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Notifikasi Foreground Diterima!');

      if (message.notification != null) {
        debugPrint('Judul: ${message.notification?.title}');
        _showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('User menekan notifikasi: ${message.notification?.title}');
    });
  }

  void _showNotification(RemoteMessage message) {
    final notification = message.notification;
    final android = message.notification?.android;
    final data = message.data;

    if (notification != null && android != null) {
      final String tipeNotif = data['tipe_notif'] ?? 'general';

      String channelId;
      String channelName;

      switch (tipeNotif) {
        case 'ganti_status':
        case 'penugasan':
        case 'hasil_laporan':
          channelId = 'status_laporan_channel';
          channelName = 'Pembaruan Status Laporan';
          break;
        case 'laporan_baru':
        case 'laporan_terdekat':
        default:
          channelId = 'general_channel';
          channelName = 'Pemberitahuan Umum';
          break;
      }

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
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: data.toString(),
      );
    }
  }
}
