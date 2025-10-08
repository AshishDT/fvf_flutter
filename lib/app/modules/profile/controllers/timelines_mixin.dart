import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';

import '../../../data/enums/purchase_status.dart';
import '../../../data/models/md_purchase_result.dart';
import '../../../data/remote/revenue_cat/revenue_cat_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../ai_choosing/models/md_result.dart';
import '../../winner/repositories/winner_api_repo.dart';
import '../enums/subscription_enum.dart';
import '../models/md_user_rounds.dart';

/// TimeLine Mixin
mixin TimeLineMixin on GetxController {
  /// Round controllers
  final Map<int, PageController> roundInnerPageController =
      <int, PageController>{};

  /// Round current result index
  final Map<int, RxInt> roundCurrentResultIndex = <int, RxInt>{};

  /// Round wiggle mark
  final Map<int, RxBool> roundWiggleMark = <int, RxBool>{};

  /// Round exposed
  final Map<int, RxBool> roundExposed = <int, RxBool>{};

  /// Round purchasing
  final Map<int, RxBool> roundPurchasing = <int, RxBool>{};

  /// No screenshot
  final NoScreenshot noScreenshot = NoScreenshot.instance;

  /// Round secure
  final Map<int, RxBool> roundSecure = <int, RxBool>{};

  /// Is exposed rounds - Can be used to refresh rounds list after purchase
  final RxBool canRefreshRounds = false.obs;

  /// Rounds list
  RxList<MdRound> get rounds;

  /// Current round index
  RxInt get currentRound;

  /// Call this after rounds list is loaded or updated.
  void syncRoundExposureFromAccess({String? userId}) {
    final String? effectiveUserId = (userId != null && userId.isNotEmpty)
        ? userId
        : UserProvider.currentUser?.id;

    final List<MdRound> roundsList = rounds();
    for (int i = 0; i < roundsList.length; i++) {
      final MdRound r = roundsList[i];
      final bool hasAccess = r.hasAccessed == true;

      roundExposed.putIfAbsent(i, () => false.obs);
      roundExposed[i]!(hasAccess);
      roundExposed[i]!.refresh();

      final List<MdResult> allResults = (r.results ?? <MdResult>[]).toList();
      if (allResults.isEmpty) {
        continue;
      }

      final MdResult? currentUser = allResults
          .firstWhereOrNull((MdResult res) => res.userId == effectiveUserId);

      final MdResult? firstRank =
          allResults.firstWhereOrNull((MdResult res) => res.rank == 1);

      final List<MdResult> others = allResults.where((MdResult res) {
        final bool isCurrent = res.userId == effectiveUserId;
        final bool isFirst = res.rank == 1;
        return !isCurrent && !isFirst;
      }).toList();

      if (!hasAccess) {
        others.shuffle();
      }

      final List<MdResult> finalList = <MdResult>[
        if (currentUser != null) currentUser,
        if (firstRank != null && firstRank.userId != effectiveUserId) firstRank,
        ...others,
      ];

      roundsList[i] = r.copyWith(results: finalList);
    }

    rounds(roundsList);
    rounds.refresh();
  }

  /// Update round screenshot permission
  void updateRoundScreenshotPermission(int roundIdx) {
    final bool exposed = roundExposed[roundIdx]?.call() ?? false;
    final int currInner = roundCurrentResultIndex[roundIdx]?.call() ?? 0;

    if (rounds.length <= roundIdx) {
      noScreenshot.screenshotOn();
      roundSecure[roundIdx]?.call(false);
      roundSecure[roundIdx]?.refresh();
      return;
    }

    MdResult? currentResult;
    final List<MdResult>? results = rounds[roundIdx].results;

    if (results != null && currInner >= 0 && currInner < results.length) {
      currentResult = results[currInner];
    }

    if (!exposed) {
      noScreenshot.screenshotOn();
      roundSecure[roundIdx]?.call(false);
      roundSecure[roundIdx]?.refresh();
      return;
    }

    if (currentResult?.rank == 1) {
      noScreenshot.screenshotOn();
      roundSecure[roundIdx]?.call(false);
      roundSecure[roundIdx]?.refresh();
    } else {
      noScreenshot.screenshotOff();
      roundSecure[roundIdx]?.call(true);
      roundSecure[roundIdx]?.refresh();
    }
  }

  /// Ensure round controllers
  void ensureRoundControllers(int idx, int itemCount) {
    roundInnerPageController.putIfAbsent(idx, () => PageController());
    roundCurrentResultIndex.putIfAbsent(idx, () => 0.obs);
    roundWiggleMark.putIfAbsent(idx, () => false.obs);
    roundExposed.putIfAbsent(idx, () => false.obs);
    roundPurchasing.putIfAbsent(idx, () => false.obs);
    roundSecure.putIfAbsent(idx, () => false.obs);

    final RxInt curr = roundCurrentResultIndex[idx]!;
    if (itemCount == 0) {
      curr(0);
    } else if (curr() >= itemCount) {
      curr(itemCount - 1);
    }
  }

  /// Round jump to page
  Future<void> roundNextPage(int idx) async {
    final PageController? pc = roundInnerPageController[idx];
    if (pc != null && pc.hasClients) {
      await pc.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Round jump to page
  Future<void> roundPrevPage(int idx) async {
    final PageController? pc = roundInnerPageController[idx];
    if (pc != null && pc.hasClients) {
      await pc.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Round prompt
  String? roundPrompt(MdRound round) => round.prompt;

  /// Add round reaction
  Future<void> addRoundReaction({
    required String emoji,
    required String participantId,
    required String roundId,
  }) async {
    final bool? _isAdded = await WinnerApiRepo.addReaction(
      roundId: roundId,
      emoji: emoji,
      participantId: participantId,
    );

    if (_isAdded == true) {
      final int roundIndex =
          rounds.indexWhere((MdRound r) => r.roundId == roundId);
      if (roundIndex != -1) {
        final int participantIndex = rounds[roundIndex]
                .results
                ?.indexWhere((MdResult p) => p.userId == participantId) ??
            -1;
        if (participantIndex != -1) {
          rounds[roundIndex].results?[participantIndex].reactions = emoji;
          rounds.refresh();
        }
      }
    } else {
      appSnackbar(
        message: 'Failed to add reaction. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    }
  }

  /// Handle round subscription
  Future<void> handleRoundSubscription({
    required int index,
    required SubscriptionPlanEnum type,
    required String roundId,
    required String successMessage,
  }) async {
    Get.back();

    roundPurchasing.putIfAbsent(index, () => false.obs);
    roundExposed.putIfAbsent(index, () => false.obs);

    roundPurchasing[index]!(true);
    roundPurchasing[index]!.refresh();

    MdPurchaseResult? result;
    try {
      switch (type) {
        case SubscriptionPlanEnum.weekly:
          result =
              await RevenueCatService.instance.purchaseWeeklySubscription();
          break;
        case SubscriptionPlanEnum.oneTime:
          result = await RevenueCatService.instance.purchaseCurrentRound(
            roundId: roundId,
          );
          break;
      }

      if (result.status == PurchaseStatus.success) {
        if (type == SubscriptionPlanEnum.weekly) {
          for (int i = 0; i < rounds.length; i++) {
            roundExposed.putIfAbsent(i, () => false.obs);
            roundExposed[i]!(true);
            roundExposed[i]!.refresh();

            rounds[i] = rounds[i].copyWith(hasAccessed: true);

            final List<MdResult> sortedResults = List<MdResult>.from(
              rounds[i].results ?? <dynamic>[],
            )..sort(
                (MdResult a, MdResult b) => a.rank?.compareTo(b.rank ?? 1) ?? 1,
              );
            rounds[i] = rounds[i].copyWith(results: sortedResults);

            updateRoundScreenshotPermission(i);
          }
          rounds.refresh();
        } else {
          roundExposed[index]!(true);
          roundExposed[index]!.refresh();

          rounds[index] = rounds[index].copyWith(hasAccessed: true);

          final List<MdResult> sortedResults = List<MdResult>.from(
            rounds[index].results ?? <dynamic>[],
          )..sort(
              (MdResult a, MdResult b) => a.rank?.compareTo(b.rank ?? 1) ?? 1);
          rounds[index] = rounds[index].copyWith(results: sortedResults);

          rounds.refresh();

          updateRoundScreenshotPermission(index);
        }

        canRefreshRounds(true);

        appSnackbar(
          message: successMessage,
          snackbarState: SnackbarState.success,
        );
      } else {
        appSnackbar(
          message:
              'Purchase failed or was cancelled. Status: ${result.status.name}',
          snackbarState: SnackbarState.danger,
        );
        canRefreshRounds(false);
      }
    } on Exception catch (e) {
      canRefreshRounds(false);
      appSnackbar(
        message: 'Error occurred: $e',
        snackbarState: SnackbarState.danger,
      );
    } finally {
      roundPurchasing[index]!(false);
      roundPurchasing[index]!.refresh();
    }
  }
}
