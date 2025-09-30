import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../data/remote/deep_link/deep_link_service.dart';

/// Auth Controller
class AuthController extends GetxController {
  /// On init
  @override
  void onInit() {
    DeepLinkService.initBranchListener();
    super.onInit();
    requestNotificationPermission();
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

  /// isNotificationEnabled
  RxBool isNotificationEnabled = false.obs;

  /// Check current notification permission at startup
  Future<void> checkInitialPermission() async {
    final PermissionStatus status = await Permission.notification.status;
    isNotificationEnabled(status.isGranted);
    if(!isNotificationEnabled()) {
      await requestNotificationPermission();
    }
  }

  /// Request notification permission
  Future<void> requestNotificationPermission() async {
    final PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      isNotificationEnabled(true);
    } else if (status.isDenied) {
      isNotificationEnabled(false);
    } else if (status.isPermanentlyDenied) {
      isNotificationEnabled(false);
    }
  }

  /// Open notification settings
  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }
}
