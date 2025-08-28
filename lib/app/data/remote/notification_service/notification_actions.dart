import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_handler.dart';

/// Handle onMessage, onLaunch and onResume events
void onPush(RemoteMessage message) {
  hasNewNotification(false);
}

/// Handle local notification
void onLocal(Map<String, dynamic> payload) {
  hasNewNotification(false);
}
