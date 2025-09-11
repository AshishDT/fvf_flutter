import 'dart:async';

import 'package:fvf_flutter/app/modules/ai_choosing/models/md_crew.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';

/// CrewStreakController
class CrewStreakController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['crew'] != null) {
        crew = Get.arguments['crew'] as MdCrew;
      }

      if (Get.arguments['participants'] != null) {
        participants = Get.arguments['participants'] as List<MdParticipant>;
      }

      startCountdown();
    }
    super.onInit();
  }

  /// On close
  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  /// List of participants
  List<MdParticipant> participants = <MdParticipant>[];

  /// Crew
  MdCrew crew = MdCrew();

  /// Timer for countdown
  Timer? timer;

  /// Seconds left for countdown
  RxInt secondsLeft = 6.obs;

  /// Function to be called after countdown
  void startCountdown() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        if (secondsLeft > 0) {
          secondsLeft.value--;
        } else {
          t.cancel();
          if(Get.currentRoute == Routes.CREW_STREAK){
            Get.back();
          }
        }
      },
    );
  }
}
