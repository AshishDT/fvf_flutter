import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:get/get.dart';
import '../../../data/config/env_config.dart';
import '../../../routes/app_pages.dart';
import '../repositories/socket_io_results.dart';

/// AiChoosingController
class AiChoosingController extends GetxController {
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

  @override
  void onInit() {
    super.onInit();

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

        Future<void>.delayed(
          const Duration(seconds: 10),
          () {
            if (participants.isEmpty) {
              return;
            }

            final Random random = Random();
            final MdParticipant winner =
                participants[random.nextInt(participants().length)];

            int rankCounter = 2;
            for (final MdParticipant participant in participants()) {
              if (participant.id == winner.id) {
                participant.rank = 1;
              } else {
                participant.rank = rankCounter;
                rankCounter++;
              }
            }

            Get.toNamed(
              Routes.WINNER,
              arguments: <String, dynamic>{
                'participants': <MdParticipant>[...participants()],
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

      resultsRepo
        ..initSocket(url: EnvConfig.socketUrl)
        ..listenForRoundProcess(
          (dynamic data) {
            logI('🎯 Round process update: $data');
          },
        );
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    pageController.dispose();
    resultsRepo.dispose();
    super.onClose();
  }

  /// Socket.IO repository instance
  final SocketIoResultsRepo resultsRepo = SocketIoResultsRepo();
}
