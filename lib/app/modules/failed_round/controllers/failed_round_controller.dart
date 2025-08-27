import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:get/get.dart';

import '../../../data/models/md_join_invitation.dart';
import '../../../routes/app_pages.dart';
import '../../create_bet/models/md_participant.dart';

/// Failed round controller
class FailedRoundController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['reason'] != null) {
        reason = Get.arguments['reason'] as String;
      }

      if (Get.arguments['sub_reason'] != null) {
        subReason = Get.arguments['sub_reason'] as String;
      }

      if (Get.arguments['round'] != null) {
        round = Get.arguments['round'] as MdRound;
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

  /// Reason for failure
  String reason = '';

  /// Sub-reason for failure
  String subReason = '';

  /// Round
  MdRound round = MdRound();

  /// On lets go again
  void onLetsGoAgain() {
    final MdJoinInvitation _joinInvitation = MdJoinInvitation(
      id: round.id ?? '',
      createdAt: round.createdAt?.toIso8601String(),
      type: round.id,
      prompt: round.prompt ?? '',
      isCustomPrompt: round.isCustomPrompt ?? false,
      isActive: round.isActive ?? false,
      isDeleted: round.isDeleted ?? false,
      status: round.status?.value,
      updatedAt: round.updatedAt?.toIso8601String(),
      roundJoinedEndAt: round.roundJoinedEndAt,
      participants: <MdParticipant>[
        MdParticipant(
          createdAt: DateTime.now().toIso8601String(),
          id: round.host?.id ?? '',
          isActive: true,
          isDeleted: false,
          isHost: true,
          joinedAt: DateTime.now().toIso8601String(),
          userData: round.host,
        ),
      ],
      host: round.host,
    );

    Get.offNamed(
      Routes.SNAP_SELFIES,
      arguments: _joinInvitation,
    );
  }
}
