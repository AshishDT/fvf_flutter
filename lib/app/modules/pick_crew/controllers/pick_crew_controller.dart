import 'dart:async';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/models/md_join_invitation.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../routes/app_pages.dart';

/// Pick crew controller
class PickCrewController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      round.value = Get.arguments as MdRound;
      round.refresh();

      startTimer();
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

  /// Observable for bet text
  Rx<MdRound> round = MdRound().obs;

  /// Seconds left for the timer
  RxInt secondsLeft = 300.obs;

  /// Timer for countdown
  Timer? _timer;

  /// Share Uri
  Future<void> shareUri() async {
    try {
      final String? _invitationLink =
          await DeepLinkService.generateSlayInviteLink(
        title: round().prompt ?? '',
        invitationId: round().id ?? '',
      );

      if (_invitationLink == null || _invitationLink.isEmpty) {
        appSnackbar(
          message: 'Failed to generate invitation link. Please try again.',
          snackbarState: SnackbarState.danger,
        );
        return;
      }

      final Uri uri = Uri.parse(_invitationLink);

      unawaited(
        SharePlus.instance
            .share(
          ShareParams(
            uri: uri,
            title: 'Slay',
            subject: 'Slay Invitation',
          ),
        ).then(
          (ShareResult result) {
            Get.toNamed(
              Routes.SNAP_SELFIES,
              arguments: MdJoinInvitation(
                id: round().id ?? '',
                createdAt: round().createdAt?.toIso8601String(),
                type: round().id,
                prompt: round().prompt ?? '',
                isCustomPrompt: round().isCustomPrompt ?? false,
                isActive: round().isActive ?? false,
                isDeleted: round().isDeleted ?? false,
                status: round().status?.value,
                updatedAt: round().updatedAt?.toIso8601String(),
                roundJoinedEndAt: round().roundJoinedEndAt,
                participants: <MdParticipant>[
                  MdParticipant(
                    createdAt: DateTime.now().toIso8601String(),
                    id: round().host?.id ?? '',
                    isActive: true,
                    isDeleted: false,
                    isHost: true,
                    joinedAt: DateTime.now().toIso8601String(),
                    userData: round().host,
                  ),
                ],
                host: round().host,
              ),
            );
          },
        ),
      );
    } on Exception {
      logE('Error sharing invitation link');
    }
  }

  /// Start timer
  void startTimer() {
    _timer?.cancel();

    final DateTime? endTime = round().roundJoinedEndAt;

    if (endTime == null) {
      secondsLeft.value = 300;
    } else {
      final DateTime localEndTime = endTime.toLocal();
      final int diffInSeconds =
          localEndTime.difference(DateTime.now()).inSeconds;

      if (diffInSeconds <= 0) {
        _handleTimeUp();
        return;
      }

      secondsLeft.value = diffInSeconds;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (secondsLeft.value > 0) {
          secondsLeft.value--;
        } else {
          _handleTimeUp();
          timer.cancel();
        }
      },
    );
  }

  /// Handle what happens when timer finishes
  void _handleTimeUp() {
    if (Get.currentRoute == Routes.PICK_CREW) {
      Get
        ..back()
        ..toNamed(
          Routes.FAILED_ROUND,
          arguments: <String, dynamic>{
            'reason': 'Only you joined..',
            'round': round(),
            'sub_reason': 'Go again with your friends',
          },
        );
    }
  }
}
