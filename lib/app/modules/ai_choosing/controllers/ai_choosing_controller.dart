import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../snap_selfies/models/md_user_selfie.dart';

/// AiChoosingController
class AiChoosingController extends GetxController {
  /// PageController for the PageView
  late PageController pageController;

  /// Timer for auto-scrolling
  Timer? timer;

  /// List of selfies taken by the user
  RxList<MdUserSelfie> selfies = <MdUserSelfie>[].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      final List<MdUserSelfie> _selfies = Get.arguments as List<MdUserSelfie>;

      if (_selfies.isNotEmpty) {
        for (final MdUserSelfie selfie in _selfies) {
          if (selfie.id == 'current_user') {
            selfie.selfieUrl = 'https://picsum.photos/seed/picsum/200/300';
          } else {
            if (selfie.selfieUrl == null || selfie.selfieUrl!.isEmpty) {
              selfie.selfieUrl = 'https://picsum.photos/id/237/200/300';
            }
          }
        }

        selfies.value = _selfies;
        selfies.refresh();

        // Infinite looping carousel effect by starting at a high page
        pageController = PageController(
          viewportFraction: 0.55,
          initialPage: 1000,
        );

        // Auto-scroll every 2 seconds
        timer = Timer.periodic(
          const Duration(seconds: 2),
          (Timer t) {
            if (pageController.hasClients) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
        );
      }
    }
  }

  @override
  void onClose() {
    // Cancel timer and dispose controller when closing
    timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
