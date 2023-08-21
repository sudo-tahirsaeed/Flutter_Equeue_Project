import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification({
    int? id,
    String? title,
    String? body,
// Optional arguments
    NotificationDetails? platformChannelSpecifics,
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id ?? 0,
      title ?? '',
      body ?? '',
      platformChannelSpecifics ?? null,
      payload: payload ?? '',
    );
  }
}