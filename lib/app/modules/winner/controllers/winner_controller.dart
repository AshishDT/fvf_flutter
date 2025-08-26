import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/models/md_join_invitation.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:get/get.dart';

/// Winner Controller
class WinnerController extends GetxController {
  /// isExposed
  RxBool isExposed = false.obs;

  /// Current rank
  RxInt currentRank = 0.obs;

  /// pageController
  PageController? pageController = PageController(initialPage: 0);

  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['participants'] != null) {
        final List<MdParticipant> _selfies = Get.arguments['participants'] as List<MdParticipant>;

        WidgetsBinding.instance.addPostFrameCallback(
              (Duration timeStamp) {
            if (_selfies.isNotEmpty) {
              _selfies.sort((MdParticipant a, MdParticipant b) =>
              a.rank?.compareTo(b.rank ?? 0) ?? 0);

              participants.value = List<MdParticipant>.from(_selfies);
              pageController = PageController(initialPage: 0);
            }
          },
        );
      }

      if (Get.arguments['bet'] != null) {
        bet.value = Get.arguments['bet'] as String;
        bet.refresh();
      }
    }
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
    pageController?.dispose();
    super.onClose();
  }

  /// bet
  RxString bet = ''.obs;

  /// nextPage
  void nextPage() {
    if (pageController != null && pageController!.hasClients) {
      pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// prevPage
  void prevPage() {
    if (pageController != null && pageController!.hasClients) {
      pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// List of selfies taken by the user
  RxList<MdParticipant> participants = <MdParticipant>[].obs;
}
