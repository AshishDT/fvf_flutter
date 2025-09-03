import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_actions_handler.dart';
import 'notification_handler.dart';

/// Handle onMessage, onLaunch and onResume events
void onPush(RemoteMessage message) {
  hasNewNotification(false);

  log(
    'Notification Message: ${message.toMap()}',
  );

  if (message.data.isNotEmpty) {
    final bool isRoundIdNotEmpty = message.data['round_id'] != null &&
        message.data['round_id'].toString().isNotEmpty;

    if (isRoundIdNotEmpty) {
      final String roundId = message.data['round_id'].toString();

      NotificationActionsHandler.handleRoundDetails(
        roundId: roundId,
      );
    }
  }
}

/// Handle local notification
void onLocal(Map<String, dynamic> payload) {
  hasNewNotification(false);

  log(
    'Local Notification Payload: $payload',
  );

  final bool isRoundIdNotEmpty =
      payload['round_id'] != null && payload['round_id'].toString().isNotEmpty;

  if (isRoundIdNotEmpty) {
    final String roundId = payload['round_id'].toString();

    NotificationActionsHandler.handleRoundDetails(
      roundId: roundId,
    );
  }
}
