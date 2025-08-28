import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

/// Has new notification
RxBool hasNewNotification = false.obs;

/// NotificationHandler is a singleton class that handles push notifications
class NotificationHandler {
  /// Factory constructor to return the same instance
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Private constructor
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Instance of NotificationHandler
  Function(RemoteMessage)? onPushNotification;

  /// Callback for local notifications
  Function(Map<String, dynamic>)? onLocalNotification;

  /// Initialize Firebase Messaging and Local Notifications
  Future<void> handleInitialMessage() async {
    final RemoteMessage? message = await firebaseMessaging.getInitialMessage();

    /// On push notification tap
    if (message != null) {
      hasNewNotification(false);
      onPushNotification?.call(message);
    }
  }

  /// Initialize local notifications
  void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        logI('Foreground message received: ${message.toMap()}');
        if (message.notification != null) {
          hasNewNotification(true);
        }

        showLocalNotification(message);
      },
    );
  }

  /// Listen to notification taps
  void listenToNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        hasNewNotification(false);
        onPushNotification?.call(message);
      },
    );
  }

  /// Handle notification tap when the app is in the background
  Future<void> onSelectLocalNotification(NotificationResponse? response) async {
    if (response?.payload != null) {
      final Map<String, dynamic> payload = jsonDecode(response!.payload!);
      hasNewNotification(false);
      onLocalNotification?.call(payload);
    }
  }

  /// Show local notification
  Future<void> showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.grey,
      colorized: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformDetails,
      payload: jsonEncode(message.data),
    );
  }

  /// Get FCM token
  Future<String?> getToken() async => firebaseMessaging.getToken();
}
