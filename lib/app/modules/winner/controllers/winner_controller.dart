import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
import 'package:fvf_flutter/app/modules/profile/enums/subscription_enum.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
import 'package:fvf_flutter/app/modules/winner/models/md_round_details.dart';
import 'package:fvf_flutter/app/modules/winner/repositories/winner_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';

import '../../ai_choosing/models/md_ai_result.dart';

/// Winner Controller
class WinnerController extends GetxController {
  /// roundId
  RxString roundId = ''.obs;

  /// RxList<MdResult>
  RxList<MdResult> results = <MdResult>[].obs;

  /// isPurchasing
  RxBool isPurchasing = false.obs;

  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['isFromProfile'] != null) {
        isFromProfile(true);
      }
      if (Get.arguments['roundId'] != null) {
        roundId(Get.arguments['roundId']);
        getRoundDetails(
          Get.arguments['roundId'],
        );
      }

      if (Get.arguments['result_data'] != null) {
        _resultData.value = Get.arguments['result_data'] as MdAiResultData;
        _resultData.refresh();

        getRoundDetails(
          _resultData().id ?? '',
        );
      }
      WidgetsBinding.instance.addPostFrameCallback(
        (Duration timeStamp) {
          pageController = PageController();
        },
      );
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

  /// isExposed
  RxBool isExposed = false.obs;

  /// isFromProfile
  RxBool isFromProfile = false.obs;

  /// Current rank
  RxInt currentRank = 0.obs;

  /// Is data loading
  RxBool isLoading = true.obs;

  /// Wiggle question mark
  RxBool wiggleQuestionMark = false.obs;

  /// Result data
  /*RxList<MdResult> get results {
    final List<MdResult> allResults =
        (roundDetails().round?.results ?? <MdResult>[]).toList();

    final MdResult? firstRank =
        allResults.firstWhereOrNull((MdResult r) => r.rank == 1);

    final List<MdResult> others =
        allResults.where((MdResult r) => r.rank != 1).toList()..shuffle();

    final List<MdResult> finalList = <MdResult>[
      if (firstRank != null) firstRank,
      ...others,
    ];

    return finalList.obs;
  }*/

  /// Prompt
  RxString get prompt => (roundDetails().round?.prompt ?? '').obs;

  /// pageController
  PageController? pageController = PageController(initialPage: 0);

  /// Observable result data
  final Rx<MdAiResultData> _resultData = MdAiResultData().obs;

  /// Observable round details
  Rx<MdRoundDetails> roundDetails = MdRoundDetails().obs;

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

  /// Get round details
  Future<void> getRoundDetails(String roundId) async {
    isLoading(true);
    try {
      final MdRoundDetails? _roundDetails =
          await WinnerApiRepo.getRoundDetails(roundId: roundId);

      roundDetails(_roundDetails);
      roundDetails.refresh();
      isExposed(_roundDetails?.hasAccess ?? false);
      isExposed.refresh();
      final List<MdResult> allResults =
          (roundDetails().round?.results ?? <MdResult>[]).toList();

      final MdResult? firstRank =
          allResults.firstWhereOrNull((MdResult r) => r.rank == 1);

      final List<MdResult> others =
          allResults.where((MdResult r) => r.rank != 1).toList()..shuffle();

      final List<MdResult> finalList = <MdResult>[
        if (firstRank != null) firstRank,
        ...others,
      ];
      results(finalList);
      results.refresh();
    } finally {
      isLoading(false);
    }
  }

  /// Add reaction
  Future<void> addReaction({
    required String emoji,
    required String participantId,
  }) async {
    final bool? _isAdded = await WinnerApiRepo.addReaction(
      roundId: _resultData().id ?? '',
      emoji: emoji,
      participantId: participantId,
    );

    if (_isAdded == true) {
      for (final MdResult result in results) {
        if (participantId == result.userId) {
          if (_isAdded == true) {
            result.reaction = emoji;
          }
          results.refresh();
          roundDetails.refresh();
          break;
        }
      }
    } else {
      appSnackbar(
        message: 'Failed to add reaction. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    }
  }

  /// Round Subscription
  Future<bool> roundSubscription({
    required String roundId,
    required String paymentId,
    required SubscriptionPlanEnum type,
  }) async {
    try {
      isPurchasing(true);
      final bool _isPurchase = await ProfileApiRepo.roundSubscription(
        roundId: roundId,
        paymentId: paymentId,
        type: type,
      );
      if (_isPurchase) {
        return _isPurchase;
      }
      return false;
    } on Exception catch (e) {
      isPurchasing(false);
      return false;
    } finally {
      isPurchasing(false);
    }
  }
}
