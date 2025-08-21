import 'package:fvf_flutter/app/modules/winner/models/emoji_model.dart';
import 'package:get/get.dart';

import '../../snap_selfies/models/md_user_selfie.dart';

/// Winner Controller
class WinnerController extends GetxController {

  /// isExposed
  RxBool isExposed = false.obs;

  /// Emoji reactions
  RxList<EmojiReaction> emojiReactions = <EmojiReaction>[
    EmojiReaction(emoji: '😎', count: 2),
    EmojiReaction(emoji: '😂', count: 11),
    EmojiReaction(emoji: '🔥', count: 5),
    EmojiReaction(emoji: '👀', count: 80),
  ].obs;

  /// Track the index of the emoji the user has reacted with (-1 = none)
  RxInt userReactionIndex = (-1).obs;

  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['selfies'] != null) {
        final List<MdUserSelfie> _selfies =
            Get.arguments['selfies'] as List<MdUserSelfie>;

        if (_selfies.isNotEmpty) {
          _selfies.sort((MdUserSelfie a, MdUserSelfie b) =>
              a.rank?.compareTo(b.rank ?? 0) ?? 0);

          selfies.value = _selfies;
          selfies.refresh();
        }
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
    super.onClose();
  }

  /// List of selfies taken by the user
  RxList<MdUserSelfie> selfies = <MdUserSelfie>[].obs;

  /// Observable for bet text
  RxString bet = ''.obs;

  /// Get first rank
  Rx<MdUserSelfie> get firstRank =>
      selfies().firstWhere((u) => u.rank == 1).obs;

  /// Get second rank
  Rx<MdUserSelfie> get secondRank =>
      selfies().firstWhere((u) => u.rank == 2).obs;

  /// Get third rank
  Rx<MdUserSelfie> get thirdRank =>
      selfies().firstWhere((u) => u.rank == 3).obs;

  /// Handle emoji tap
  void handleEmojiTap(int index) {
    if (userReactionIndex() == -1) {
      emojiReactions[index].count++;
      userReactionIndex(index);
    } else if (userReactionIndex() == index) {
      emojiReactions[index].count--;
      userReactionIndex(-1);
    } else {
      emojiReactions[userReactionIndex()].count--;
      emojiReactions[index].count++;
      userReactionIndex(index);
    }
    emojiReactions.refresh();
  }
}
