import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:get/get.dart';
import '../../../data/config/env_config.dart';
import '../../../data/remote/socket_io_repo.dart';
import '../../../routes/app_pages.dart';
import '../../create_bet/models/md_round.dart';
import '../../failed_round/repositories/failed_round_api_repo.dart';
import '../models/md_ai_result.dart';

/// AiChoosingController
class AiChoosingController extends GetxController with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    if (timer != null) {
      timer?.cancel();
    }

    if (pageController.hasClients) {
      pageController.dispose();
    }
    socketIoRepo.disconnect();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        log(
          'App resumed -> reconnect socket',
        );
        socketIoRepo
          ..initSocket(url: EnvConfig.socketUrl)
          ..listenForRoundProcess(
            (dynamic data) {
              _onResults(data);
            },
          );
        break;
      case AppLifecycleState.paused:
        log(
          'App paused -> disconnect socket',
        );
        socketIoRepo.disconnect();
        break;
      default:
        break;
    }
  }

  /// Socket.IO repository instance
  final SocketIoRepo socketIoRepo = SocketIoRepo();

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

  /// Is waking up
  RxBool isWakingUp = false.obs;

  /// Is view only
  RxBool isViewOnly = false.obs;

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

      if (Get.arguments['is_view_only'] != null) {
        final bool _isViewOnly = Get.arguments['is_view_only'] as bool;
        isViewOnly.value = _isViewOnly;
      }

      if (Get.arguments['bet'] != null) {
        bet.value = Get.arguments['bet'] as String;
        bet.refresh();
      }

      socketIoRepo
        ..initSocket(url: EnvConfig.socketUrl)
        ..listenForRoundProcess(
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
      if (Get.currentRoute != Routes.WINNER) {
        socketIoRepo.disconnect();
        Get.offNamedUntil(
          Routes.WINNER,
          (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
          arguments: <String, dynamic>{
            'result_data': resultData,
          },
        );
      }

      return;
    }

    if (isFailed) {
      isAiFailed(true);
      isAiFailed.refresh();
      return;
    }
  }

  /// Wake it up
  Future<void> wakeItUp() async {
    isWakingUp(true);
    try {
      final MdRound? _round = await FailedRoundApiRepo.reRun(
        roundId: resultData.value.id ?? '',
      );

      if (_round != null) {
        isAiFailed(false);
        isAiFailed.refresh();

        socketIoRepo
          ..disconnect()
          ..initSocket(url: EnvConfig.socketUrl)
          ..listenForRoundProcess(
            (dynamic data) {
              _onResults(data);
            },
          );
      }
    } finally {
      isWakingUp(false);
    }
  }
}
