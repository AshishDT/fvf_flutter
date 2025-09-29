import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
import 'package:get/get.dart';

import '../../../modules/ai_choosing/enums/round_status_enum.dart';
import '../../../modules/ai_choosing/models/md_ai_result.dart';
import '../../../modules/create_bet/models/md_participant.dart';
import '../../../modules/create_bet/models/md_round.dart';
import '../../../modules/winner/models/md_round_details.dart';
import '../../../modules/winner/repositories/winner_api_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_loader.dart';
import '../../models/md_join_invitation.dart';

/// Notification Actions Handler
class NotificationActionsHandler {
  /// Handle notification action
  static Future<void> handleRoundDetails({
    required String roundId,
    bool isViewOnly = false,
  }) async {
    Loader.show();
    try {
      final MdRoundDetails? _roundDetails =
          await WinnerApiRepo.getRoundDetails(roundId: roundId);

      if (_roundDetails != null) {
        Loader.dismiss();

        final RoundStatus status =
            _roundDetails.round?.status ?? RoundStatus.pending;

        switch (status) {
          case RoundStatus.started:
          case RoundStatus.pending:
            final MdRound? _round = _roundDetails.round;

            if (_round == null) {
              return;
            }

            final bool isHost =
                _roundDetails.round?.host?.id == UserProvider.userId;

            _onPendingStatus(
              round: _round,
              isViewOnly: isViewOnly,
              isHost: isHost,
            );
            break;
          case RoundStatus.processing:
            final List<MdParticipant>? participants =
                _roundDetails.round?.participants;

            if (participants == null || participants.isEmpty) {
              return;
            }

            final bool isHost =
                _roundDetails.round?.host?.id == UserProvider.userId;

            _handleProcessingRound(
              participants: participants,
              prompt: _roundDetails.round?.prompt ?? '',
              roundId: roundId,
              isHost: isHost,
              isViewOnly: isViewOnly,
              hostId: _roundDetails.round?.host?.id ?? '',
            );
            break;
          case RoundStatus.completed:
            final List<MdResult>? results = _roundDetails.round?.results;

            if (results == null || results.isEmpty) {
              return;
            }

            final DateTime? revealAt = _roundDetails.round?.revealAt;

            _onCompleted(
              revealAt: revealAt,
              status: status,
              results: results,
              roundId: roundId,
              host: _roundDetails.round?.host,
              prompt: _roundDetails.round?.prompt ?? '',
              isViewOnly: isViewOnly,
            );
            break;
          case RoundStatus.failed:
            final List<MdParticipant>? participants =
                _roundDetails.round?.participants;

            if (participants == null || participants.isEmpty) {
              return;
            }

            final bool isHost =
                _roundDetails.round?.host?.id == UserProvider.userId;
            _fallBackToStartAgain(
              isHost: isHost,
              participants: participants,
              roundId: roundId,
              isViewOnly: isViewOnly,
              prompt: _roundDetails.round?.prompt ?? '',
              hostId: _roundDetails.round?.host?.id ?? '',
            );
            break;
        }
      }
      Loader.dismiss();
    } on Exception {
      Loader.dismiss();
    } finally {
      Loader.dismiss();
    }
  }

  /// On completed
  static void _onCompleted({
    required String prompt,
    required String roundId,
    required List<MdResult> results,
    required RoundStatus status,
    DateTime? revealAt,
    RoundHost? host,
    bool? isViewOnly,
  }) {
    Get.offNamedUntil(
      Routes.WINNER,
      (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      arguments: <String, dynamic>{
        'result_data': MdAiResultData(
          prompt: prompt,
          host: host,
          id: roundId,
          results: results,
          status: status,
          revealAt: revealAt,
          isViewOnly: isViewOnly,
        ),
      },
    );
  }

  /// On pending status
  static void _onPendingStatus({
    required MdRound round,
    bool? isViewOnly,
    bool isHost = false,
  }) {
    if (isHost && Get.currentRoute == Routes.SNAP_SELFIES) {
      return;
    }

    Get.offNamedUntil(
      Routes.SNAP_SELFIES,
      (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      arguments: MdJoinInvitation(
        id: round.id ?? '',
        createdAt: round.createdAt?.toIso8601String(),
        type: round.id,
        prompt: round.prompt ?? '',
        isCustomPrompt: round.isCustomPrompt ?? false,
        isActive: round.isActive ?? false,
        isDeleted: round.isDeleted ?? false,
        status: round.status,
        updatedAt: round.updatedAt?.toIso8601String(),
        roundJoinedEndAt: round.roundJoinedEndAt,
        previousRounds: round.previousRounds,
        isAlreadyJoined: isHost,
        participants: round.participants,
        host: round.host,
        isViewOnly: isViewOnly,
      ),
    );
  }

  /// Handle processing round
  static void _handleProcessingRound({
    required List<MdParticipant> participants,
    required String prompt,
    required String roundId,
    required String hostId,
    bool isHost = false,
    bool isViewOnly = false,
  }) {
    final List<MdParticipant> participantsWithSelfies = participants
        .where((MdParticipant participant) =>
            participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty)
        .toList();

    final bool canStartRound = participantsWithSelfies.length >= 2;

    if (canStartRound) {
      _navigateToAiChoosing(
        participants: participantsWithSelfies,
        prompt: prompt,
        isViewOnly: isViewOnly,
      );
    } else {
      _fallBackToStartAgain(
        participants: participants,
        isHost: isHost,
        roundId: roundId,
        isViewOnly: isViewOnly,
        prompt: prompt,
        hostId: hostId,
      );
    }
  }

  /// On let go
  static void _navigateToAiChoosing({
    required List<MdParticipant> participants,
    required String prompt,
    bool isViewOnly = false,
  }) {
    Get.offNamedUntil(
      Routes.AI_CHOOSING,
      (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      arguments: <String, dynamic>{
        'participants': participants,
        'bet': prompt,
        'from_notification': true,
        'is_view_only': isViewOnly,
      },
    );
  }

  /// Fall back to start again
  static void _fallBackToStartAgain({
    required List<MdParticipant> participants,
    required String roundId,
    required String hostId,
    required String prompt,
    required bool isHost,
    bool isViewOnly = false,
  }) {
    final MdParticipant selfParticipant = participants.firstWhere(
      (MdParticipant participant) => participant.isCurrentUser,
      orElse: () => MdParticipant(),
    );

    List<MdParticipant> participantsWithoutCurrentUser() {
      final List<MdParticipant> list = participants
          .where((MdParticipant participant) => !participant.isCurrentUser)
          .toList();

      final Map<String?, MdParticipant> uniqueMap = <String?, MdParticipant>{
        for (final MdParticipant p in list) p.userData?.id: p
      };

      return uniqueMap.values.toList();
    }

    final Map<String, dynamic> currentArgs = <String, dynamic>{
      'reason': isViewOnly ? 'Round failed' : 'Only you joined..',
      'round_id': roundId,
      'is_host': isHost,
      'sub_reason': isViewOnly
          ? 'Not enough participants joined to start round'
          : 'Go again with your friends',
      'self_participant': selfParticipant,
      'participants_without_current_user': participantsWithoutCurrentUser(),
      'host_id': hostId,
      'prompt': prompt,
      'is_view_only': isViewOnly,
    };

    Get.offNamedUntil(
      Routes.FAILED_ROUND,
      (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      arguments: currentArgs,
    );
  }
}
