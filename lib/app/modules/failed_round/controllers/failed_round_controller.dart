import 'dart:async';

import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/app_loader.dart';
import '../../create_bet/models/md_participant.dart';
import '../repositories/failed_round_api_repo.dart';

/// Failed round controller
class FailedRoundController extends GetxController {
  /// participantsWithoutCurrentUser
  RxList<MdParticipant> participantsWithoutCurrentUser = <MdParticipant>[].obs;

  /// Self Participant
  Rx<MdParticipant> selfParticipant = MdParticipant().obs;

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

      if (Get.arguments['host_id'] != null) {
        hostId = Get.arguments['host_id'] as String;
      }

      if (Get.arguments['prompt'] != null) {
        prompt = Get.arguments['prompt'] as String;
      }

      if (Get.arguments['is_view_only'] != null) {
        isViewOnly = Get.arguments['is_view_only'] as bool;
      }

      if (Get.arguments['round_id'] != null) {
        roundId = Get.arguments['round_id'];
      }

      if (Get.arguments['is_host'] != null) {
        isHost = Get.arguments['is_host'] as bool;
      }

      if (Get.arguments['self_participant'] != null) {
        selfParticipant(Get.arguments['self_participant']);
      }

      if (Get.arguments['participants_without_current_user'] != null) {
        participantsWithoutCurrentUser.clear();
        participantsWithoutCurrentUser(
            Get.arguments['participants_without_current_user']);
        if (participantsWithoutCurrentUser().isEmpty) {
          participantsWithoutCurrentUser(<MdParticipant>[
            MdParticipant(),
            MdParticipant(),
            MdParticipant(),
          ]);
        }
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
  String roundId = '';

  /// Is loading
  RxBool isLoading = false.obs;

  /// Host id
  String hostId = '';

  /// Prompt
  String prompt = '';

  /// Is host
  bool isHost = false;

  /// Is view only
  bool isViewOnly = false;

  /// On re run
  Future<void> onLetsGoAgain() async {
    isLoading(true);
    try {
      final MdRound? _round = await FailedRoundApiRepo.reRun(
        roundId: roundId,
      );

      if (_round != null) {
        unawaited(
          Get.offNamed(
            Routes.SNAP_SELFIES,
            arguments: MdJoinInvitation(
              id: _round.id ?? '',
              createdAt: _round.createdAt?.toIso8601String(),
              type: _round.id,
              prompt: _round.prompt ?? '',
              isCustomPrompt: _round.isCustomPrompt ?? false,
              isActive: _round.isActive ?? false,
              isDeleted: _round.isDeleted ?? false,
              status: _round.status,
              updatedAt: _round.updatedAt?.toIso8601String(),
              roundJoinedEndAt: _round.roundJoinedEndAt,
              participants: <MdParticipant>[
                MdParticipant(
                  createdAt: DateTime.now().toIso8601String(),
                  id: _round.host?.id ?? '',
                  isActive: true,
                  isDeleted: false,
                  isHost: true,
                  joinedAt: DateTime.now().toIso8601String(),
                  userData: _round.host,
                ),
              ],
              host: _round.host,
            ),
          ),
        );
      }
    } finally {
      isLoading(false);
    }
  }

  /// Share view-only link
  Future<void> shareViewOnlyLink() async {
    Loader.show();
    try {
      final String? _uri = await DeepLinkService.generateSlayInviteLink(
        title: prompt,
        invitationId: roundId,
        hostId: hostId,
        isViewOnly: true,
      );

      if (_uri == null || _uri.isEmpty) {
        Loader.dismiss();
        appSnackbar(
          message: 'Failed to generate invitation link. Please try again.',
          snackbarState: SnackbarState.danger,
        );
        return;
      }

      Loader.dismiss();

      final Uri uri = Uri.parse(_uri);

      unawaited(
        SharePlus.instance.share(
          ShareParams(
            uri: uri,
          ),
        ),
      );
    } on Exception {
      Loader.dismiss();
    } finally {
      Loader.dismiss();
    }
  }
}
