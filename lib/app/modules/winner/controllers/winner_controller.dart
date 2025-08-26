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
    pageController = PageController(initialPage: 0);
    participants.sort((MdParticipant a, MdParticipant b) =>
        a.rank?.compareTo(b.rank ?? 0) ?? 0);
    /*if (Get.arguments != null) {
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
    }*/
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
  RxList<MdParticipant> participants = <MdParticipant>[
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1551847812-f815b31ae67c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c2VsZmllfGVufDB8fDB8fHww',
      rank: 2,
      userData: RoundHost(
        username: 'Alice Johnson',
        age: 28,
      ),
    ),
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1688597168861-b2d5f521cca6?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHNlbGZpZXxlbnwwfHwwfHx8MA%3D%3D',
      isHost: true,
      rank: 1,
      userData: RoundHost(
        username: 'Bob Smith',
        age: 20,
      ),
    ),
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1522556189639-b150ed9c4330?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c2VsZmllfGVufDB8fDB8fHww',
      rank: 3,
      userData: RoundHost(
        username: 'Diana Prince',
        age: 20,
      ),
    ),
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1612000529646-f424a2aa1bff?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNlbGZpZXxlbnwwfHwwfHx8MA%3D%3D',
      rank: 4,
      userData: RoundHost(
        username: 'Catherine Lee',
        age: 32,
      ),
    ),
  ].obs;
}
