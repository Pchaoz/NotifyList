import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperfocus/core/supabase/supabase_client.dart';
import 'package:hyperfocus/core/notifications/notification_service.dart';
import 'package:hyperfocus/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await SupabaseConfig.initialize();
  await NotificationService.initialize();

  final androidPlugin = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidPlugin?.requestNotificationsPermission();

  runApp(
    const ProviderScope(
      child: HyperfocusApp(),
    ),
  );
}
