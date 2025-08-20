import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
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

        pageController = PageController(
          viewportFraction: 0.55,
          initialPage: 1000,
        );

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

      Future<void>.delayed(
        const Duration(seconds: 10),
        () {
          if (selfies.isEmpty) return;

          final Random random = Random();
          final MdUserSelfie winner = selfies[random.nextInt(selfies.length)];

          int rankCounter = 2;
          for (final MdUserSelfie selfie in selfies) {
            if (selfie.id == winner.id) {
              selfie.rank = 1;
            } else {
              selfie.rank = rankCounter;
              rankCounter++;
            }
          }

          Get.toNamed(
            Routes.WINNER,
            arguments: selfies,
          );
        },
      );
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
