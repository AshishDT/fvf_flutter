import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';

/// Auth Controller
class AuthController extends GetxController {
  /// On init
  @override
  void onInit() {
    DeepLinkService.initBranchListener();
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

  /// Open notification settings
  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  /// Open URL
  Future<void> openUrl(String url) async {
    final Uri _url = Uri.parse(url);
    final bool _launched = await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    );

    if (!_launched) {
      appSnackbar(
        message: 'Could not launch $url',
        snackbarState: SnackbarState.danger,
      );
    }
  }
}
