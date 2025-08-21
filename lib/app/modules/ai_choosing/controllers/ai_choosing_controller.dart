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

  /// Observable for bet text
  RxString bet = ''.obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments['selfies'] != null) {
        final List<MdUserSelfie> _selfies =
            Get.arguments['selfies'] as List<MdUserSelfie>;

        if (_selfies.isNotEmpty) {
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
            if (selfies.isEmpty) {
              return;
            }

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
              arguments: <String, dynamic>{
                'selfies': <MdUserSelfie>[...selfies()],
                'bet': bet.value,
              },
            );
          },
        );
      }

      if (Get.arguments['bet'] != null) {
        bet.value = Get.arguments['bet'] as String;
        bet.refresh();
      }
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
