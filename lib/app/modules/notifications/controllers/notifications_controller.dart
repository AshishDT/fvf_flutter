import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/remote/notification_service/notification_actions_handler.dart';
import 'package:get/get.dart';
import '../models/md_notification.dart';
import '../repositories/notification_api_repo.dart';

/// Notifications Controller
class NotificationsController extends GetxController {
  /// On init
  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }

  /// On ready
  @override
  void onReady() {
    super.onReady();
  }

  /// On close
  @override
  void onClose() {
    super.onClose();
  }

  /// Is loading observable
  RxBool isLoading = false.obs;

  /// Notifications list observable
  RxList<MdNotification> notifications = <MdNotification>[].obs;

  /// Get notifications
  Future<void> getNotifications() async {
    isLoading(true);
    notifications.clear();
    try {
      final List<MdNotification>? _notifications =
          await NotificationApiRepo.getNotifications();

      if (_notifications != null && _notifications.isNotEmpty) {
        notifications.assignAll(_notifications);
      }

      isLoading(false);
    } on Exception catch (e) {
      logE('Error fetching notifications: $e');
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  /// Handle notification tap
  void onNotificationTap(MdNotification notification) {
    final String? roundId = notification.roundId;

    if (roundId != null && roundId.isNotEmpty) {
      NotificationActionsHandler.handleRoundDetails(
        roundId: roundId,
      );
    }
  }
}
