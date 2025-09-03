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
          case RoundStatus.pending:
            final MdRound? _round = _roundDetails.round;

            if (_round == null) {
              return;
            }

            _onPendingStatus(_round);
            break;
          case RoundStatus.processing:
            final List<MdParticipant>? participants =
                _roundDetails.round?.participants;

            if (participants == null || participants.isEmpty) {
              return;
            }

            final bool isHost = _roundDetails.round?.host?.supabaseId ==
                UserProvider.currentUser?.supabaseId;

            _handleProcessingRound(
              participants: participants,
              prompt: _roundDetails.round?.prompt ?? '',
              roundId: roundId,
              isHost: isHost,
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
            );
            break;
          case RoundStatus.failed:
            // Navigate to error screen
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
  }) {
    Get
      ..until(
        (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      )
      ..toNamed(
        Routes.WINNER,
        arguments: <String, dynamic>{
          'result_data': MdAiResultData(
            prompt: prompt,
            host: host,
            id: roundId,
            results: results,
            status: status,
            revealAt: revealAt,
          ),
        },
      );
  }

  /// On pending status
  static void _onPendingStatus(MdRound round) {
    Get.toNamed(
      Routes.SNAP_SELFIES,
      arguments: MdJoinInvitation(
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
        previousParticipants: round.previousParticipants,
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
        isFromInvitation: true,
        host: round.host,
      ),
    );
  }

  /// Handle processing round
  static void _handleProcessingRound({
    required List<MdParticipant> participants,
    required String prompt,
    required String roundId,
    bool isHost = false,
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
      );
    } else {
      _fallBackToStartAgain(
        participants: participants,
        isHost: isHost,
        roundId: roundId,
      );
    }
  }

  /// On let go
  static void _navigateToAiChoosing({
    required List<MdParticipant> participants,
    required String prompt,
  }) {
    Get.toNamed(
      Routes.AI_CHOOSING,
      arguments: <String, dynamic>{
        'participants': participants,
        'bet': prompt,
        'from_notification': true,
      },
    );
  }

  /// Fall back to start again
  static void _fallBackToStartAgain({
    required List<MdParticipant> participants,
    required String roundId,
    required bool isHost,
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
        for (final MdParticipant p in list) p.userData?.supabaseId: p
      };

      return uniqueMap.values.toList();
    }

    final Map<String, dynamic> currentArgs = <String, dynamic>{
      'reason': 'Only you joined..',
      'round_id': roundId,
      'is_host': isHost,
      'sub_reason': 'Go again with your friends',
      'self_participant': selfParticipant,
      'participants_without_current_user': participantsWithoutCurrentUser(),
    };

    Get.offNamed(
      Routes.FAILED_ROUND,
      arguments: currentArgs,
    );
  }
}
