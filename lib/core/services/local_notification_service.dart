import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
    );

    try {
      await _plugin.initialize(settings: settings);
      await _requestPermissions();
      _initialized = true;
    } catch (_) {
      _initialized = false;
    }
  }

  static Future<bool> showAnnouncementPreview() async {
    if (!_initialized) {
      await initialize();
    }
    if (!_initialized) {
      return false;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'community_announcements',
        'Community Announcements',
        channelDescription: 'Announcement previews from management office',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );

    try {
      await _plugin.show(
        id: 1808,
        title: 'New Announcement',
        body:
            'Elevator maintenance will be conducted on 07 Jun 2026, 10:00 - 14:00.',
        notificationDetails: details,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
