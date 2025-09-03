import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_handler.dart';

/// NotificationService is a singleton class that handles push notifications
class NotificationService {
  /// Private constructor
  factory NotificationService() => _instance;

  NotificationService._internal();

  /// Factory constructor to return the same instance
  static final NotificationService _instance = NotificationService._internal();

  /// Notification Handler instance
  final NotificationHandler _handler = NotificationHandler();

  /// Init
  Future<void> init({
    Function(RemoteMessage)? onPush,
    Function(Map<String, dynamic>)? onLocal,
  }) async {
    _handler.onPushNotification = onPush;
    _handler.onLocalNotification = onLocal;

    if (Platform.isIOS) {
      await _handler.firebaseMessaging.requestPermission(provisional: true);
    }

    await _initializeLocalNotifications();
    await _handler.handleInitialMessage();
    _handler
      ..listenToForegroundMessages()
      ..listenToNotificationTap();
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _handler.flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _handler.onSelectLocalNotification,
    );

    final NotificationAppLaunchDetails? details = await _handler
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      await _handler.onSelectLocalNotification(details!.notificationResponse);
    }
  }

  /// Get token
  Future<String?> getToken() => _handler.getToken();
}
