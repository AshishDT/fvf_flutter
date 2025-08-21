import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/models/md_user_selfie.dart';
import 'package:fvf_flutter/app/modules/winner/models/emoji_model.dart';
import 'package:get/get.dart';

/// PremiumWinnerController
class PremiumWinnerController extends GetxController {
  /// Emoji reactions
  RxList<EmojiReaction> emojiReactions = <EmojiReaction>[
    EmojiReaction(emoji: '😎', count: 2),
    EmojiReaction(emoji: '😂', count: 11),
    EmojiReaction(emoji: '🔥', count: 5),
    EmojiReaction(emoji: '👀', count: 80),
  ].obs;

  /// Current rank
  RxInt currentRank = 0.obs;

  /// pageController
  PageController? pageController;

  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['selfies'] != null) {
        final List<MdUserSelfie> _selfies = Get.arguments['selfies'] as List<MdUserSelfie>;

        WidgetsBinding.instance.addPostFrameCallback(
          (Duration timeStamp) {
            if (_selfies.isNotEmpty) {
              _selfies.sort((MdUserSelfie a, MdUserSelfie b) =>
                  a.rank?.compareTo(b.rank ?? 0) ?? 0);

              selfies.value = List<MdUserSelfie>.from(_selfies);
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
  RxList<MdUserSelfie> selfies = <MdUserSelfie>[].obs;
}
