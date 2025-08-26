import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
import 'package:fvf_flutter/app/modules/winner/models/md_round_details.dart';
import 'package:fvf_flutter/app/modules/winner/repositories/winner_api_repo.dart';
import 'package:get/get.dart';
import '../../ai_choosing/models/md_ai_result.dart';

/// Winner Controller
class WinnerController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      _resultData.value = Get.arguments as MdAiResultData;
      _resultData.refresh();

      getRoundDetails(
        _resultData().id ?? '',
      );

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

  /// Current rank
  RxInt currentRank = 0.obs;

  /// Is data loading
  RxBool isLoading = true.obs;

  /// Result data
  RxList<MdResult> get results {
    final List<MdResult> sorted =
        (roundDetails().round?.results ?? <MdResult>[]).toList()
          ..sort(
            (MdResult a, MdResult b) => (a.rank ?? 0).compareTo(b.rank ?? 0),
          );

    return sorted.obs;
  }

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
    } finally {
      isLoading(false);
    }
  }
}
