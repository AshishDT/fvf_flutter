import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:get/get.dart';

import '../../../data/local/user_provider.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_loader.dart';
import '../../ai_choosing/enums/round_status_enum.dart';
import '../../ai_choosing/models/md_ai_result.dart';
import '../../ai_choosing/models/md_result.dart';
import '../../create_bet/models/md_participant.dart';
import '../../create_bet/models/md_round.dart';
import '../../winner/models/md_round_details.dart';
import '../../winner/repositories/winner_api_repo.dart';
import '../models/md_notification.dart';
import '../repositories/notification_api_repo.dart';

/// Notifications Controller
class NotificationsController extends GetxController {
  /// On init
  @override
  void onInit() {
    getNotifications();
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

  /// Is loading observable
  RxBool isLoading = false.obs;

  /// Notifications list observable
  RxList<MdNotification> notifications = <MdNotification>[].obs;

  /// Get notifications
  Future<void> getNotifications() async {
    isLoading(true);
    notifications.clear();
    try {
      final List<MdNotification>? _notifications =
          await NotificationApiRepo.getNotifications();

      if (_notifications != null && _notifications.isNotEmpty) {
        notifications.assignAll(_notifications);
      }

      isLoading(false);
    } on Exception catch (e) {
      logE('Error fetching notifications: $e');
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  /// Handle notification tap
  void onNotificationTap(MdNotification notification) {
    final String? roundId = notification.roundId;

    if (roundId != null && roundId.isNotEmpty) {
      handleRoundDetails(roundId: roundId);
    }
  }

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
    Get.toNamed(
      Routes.WINNER,
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
    final bool isAlreadyJoined = round.participants
            ?.any((MdParticipant participant) => participant.isCurrentUser) ??
        false;

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
        status: round.status,
        updatedAt: round.updatedAt?.toIso8601String(),
        roundJoinedEndAt: round.roundJoinedEndAt,
        previousRounds: round.previousRounds,
        isAlreadyJoined: isHost || isAlreadyJoined,
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
    Get.toNamed(
      Routes.AI_CHOOSING,
      arguments: <String, dynamic>{
        'participants': participants,
        'bet': prompt,
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

    Get.toNamed(
      Routes.FAILED_ROUND,
      arguments: currentArgs,
    );
  }
}
