import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  // Reminder puntual para una tarea
  static Future<void> scheduleReminder({
    required int notificationId,
    required String title,
    required DateTime when,
    String? body,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'task_reminders',
      'Recordatorios de tareas',
      channelDescription: 'Avisos puntuales de tareas programadas',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.zonedSchedule(
      notificationId,
      title,
      body ?? 'Tienes una tarea pendiente',
      tz.TZDateTime.from(when, tz.local),
      NotificationDetails(android: androidDetails),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Ping global periódico
  static Future<void> showPingNotification({
    required int pendingCount,
  }) async {
    if (pendingCount == 0) return;

    final androidDetails = AndroidNotificationDetails(
      'global_ping',
      'Ping global',
      channelDescription: 'Recordatorio periódico de tareas pendientes',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    await _plugin.show(
      9999,
      'Hyperfocus',
      pendingCount == 1
          ? '1 tarea pendiente'
          : '$pendingCount tareas pendientes',
      NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
