import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/modules/report_app/controllers/report_app_controller.dart';
import 'package:get/get.dart';
import '../views/report_app_view.dart';

/// Report app service
class ReportAppService {
  /// Opens the claim flow if criteria match
  static Future<void> open() async {
    final ReportAppController controller = Get.put(ReportAppController());
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReportAppView(),
    ).whenComplete(
      () {
        controller.isContinueClicked(false);
        controller.selectedReason('');
        controller.detailsController.clear();
        controller.isReporting(false);
      },
    );
  }
}
