import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/report_app/repositories/report_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';

/// Report App Controller
class ReportAppController extends GetxController {
  /// On init
  @override
  void onInit() {
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

  /// Is continue clicked
  RxBool isContinueClicked = false.obs;

  /// Reasons
  final List<String> reasons = <String>[
    'Sexual Content',
    'Violent or repulsive content',
    'Hateful or abusive',
    'Harassment or bullying',
    'Imminent physical harm',
    'Harmful for dangerous',
    'Suicide or self-harm',
    'Child abuse',
    'Promotes terrorism',
    'Spam or misleading',
    'Legal issue',
  ];

  /// Selected reason
  Rx<String> selectedReason = ''.obs;

  /// Is reporting
  RxBool isReporting = false.obs;

  /// Details controller
  TextEditingController detailsController = TextEditingController();

  /// On continue
  void onContinue() {
    if (selectedReason().isEmpty) {
      appSnackbar(
        message: 'Please select a reason to continue',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    if (isContinueClicked()) {
      report();
      return;
    }

    isContinueClicked(true);
  }

  /// Report
  Future<void> report() async {
    isReporting(true);
    try {
      final String description = detailsController.text;

      final bool? _reported = await ReportApiRepo.report(
        title: selectedReason(),
        description: description.isEmpty ? null : description,
      );

      if (_reported ?? false) {
        Get.close(0);
        appSnackbar(
          message: 'Report submitted successfully',
          snackbarState: SnackbarState.success,
        );
      }

      isReporting(false);
    } on Exception catch (e) {
      logE('Error reporting || $e');
      isReporting(false);
    } finally {
      isReporting(false);
    }
  }
}
