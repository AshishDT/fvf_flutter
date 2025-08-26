import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:get/get.dart';
import '../../../data/remote/socket_io_repo.dart';
import '../../../routes/app_pages.dart';
import '../models/md_ai_result.dart';

/// AiChoosingController
class AiChoosingController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    _onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    resultsRepo.dispose();
    super.onClose();
  }

  /// Socket.IO repository instance
  final SocketIoRepo resultsRepo = SocketIoRepo();

  /// PageController for the PageView
  late PageController pageController;

  /// Current page index
  RxInt currentIndex = 0.obs;

  /// Timer for auto-scrolling
  Timer? timer;

  /// List of selfies taken by the user
  RxList<MdParticipant> participants = <MdParticipant>[].obs;

  /// Observable for bet text
  RxString bet = ''.obs;

  /// Observable for AI failure state
  RxBool isAiFailed = false.obs;

  /// On init
  void _onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['participants'] != null) {
        final List<MdParticipant> _participants =
            Get.arguments['participants'] as List<MdParticipant>;

        if (_participants.isNotEmpty) {
          participants.value = _participants;
          participants.refresh();

          pageController = PageController(initialPage: currentIndex());

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

      if (Get.arguments['bet'] != null) {
        bet.value = Get.arguments['bet'] as String;
        bet.refresh();
      }

      resultsRepo.listenForRoundProcess(
        (dynamic data) {
          _onResults(data);
        },
      );
    }
  }

  /// Observable for result data
  Rx<MdAiResultData> resultData = MdAiResultData().obs;

  /// On results received
  void _onResults(dynamic data) {
    final Map<String, dynamic> raw = data as Map<String, dynamic>;
    final MdAiResultData resultData =
        MdAiResultData.fromJson(raw['data'] as Map<String, dynamic>);

    this.resultData.value = resultData;
    this.resultData.refresh();

    final bool isComplete = resultData.status == RoundStatus.completed;

    final bool isFailed = resultData.status == RoundStatus.failed;

    if (isComplete) {
      Get
        ..until(
          (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
        )
        ..toNamed(
          Routes.WINNER,
          arguments: resultData,
        );
      return;
    }

    if (isFailed) {
      isAiFailed(true);
      isAiFailed.refresh();
      return;
    }
  }
}
