import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();

  static LocalNotificationService notificationService =
      LocalNotificationService._();
  AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
    "chat-app",
    "Local Notification",
    importance: Importance.max,
    priority: Priority.max,
  );
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotificationService() async {
    plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    AndroidInitializationSettings android =
        const AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings ios = const DarwinInitializationSettings();
    InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: ios,
    );
    await plugin.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);
    await plugin.show(0, title, body, notificationDetails);
  }

  // scheduleNotification
  Future<void> scheduleNotification() async {
    tz.Location location = tz.getLocation('Asia/kolkata');
    await plugin.zonedSchedule(
      1,
      "Big billions Day 2024 ",
      "harsh",
      tz.TZDateTime.now(location).add(const Duration(seconds: 5)),
      NotificationDetails(
        android: androidDetails,
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
