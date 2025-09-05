import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_previous_round.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:get/get.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/socket_io_repo.dart';
import '../../../routes/app_pages.dart';

/// Mixin for SnapSelfie keys
mixin SnapSelfieKeysMixin on GetxController {
  /// Observable to track keyboard visibility
  RxBool isKeyboardVisible = false.obs;

  /// Entered name
  RxString enteredName = ''.obs;

  /// Previous bottom inset for keyboard
  final RxDouble prevBottomInset = 0.0.obs;

  /// Focus node for name input field
  final FocusNode nameInputFocusNode = FocusNode();

  /// Text editing controller for name input field
  TextEditingController nameInputController = TextEditingController();

  /// Should wiggle add name
  RxBool shouldWiggleAddName = false.obs;

  /// Should wiggle snap pick
  RxBool shouldWiggleSnapPick = false.obs;

  /// User profile
  Rx<MdProfile> profile = MdProfile().obs;

  /// Share URI
  RxString deepLinkUri = ''.obs;

  /// Joined invitation data
  Rx<MdJoinInvitation> joinedInvitationData = MdJoinInvitation().obs;

  /// Check if current user is host
  RxBool get isHost =>
      (joinedInvitationData().host?.supabaseId == SupaBaseService.userId).obs;

  /// Self participant
  Rx<MdParticipant> get selfParticipant => participants()
      .firstWhere(
        (MdParticipant participant) => participant.isCurrentUser,
        orElse: () => MdParticipant(),
      )
      .obs;

  /// Participants
  RxList<MdParticipant> get participants {
    final List<MdParticipant> list =
        joinedInvitationData().participants ?? <MdParticipant>[];

    final Map<String?, MdParticipant> uniqueMap = <String?, MdParticipant>{
      for (final MdParticipant p in list) p.userData?.supabaseId: p
    };

    final List<MdParticipant> uniqueList = uniqueMap.values.toList()
      ..sort(
        (MdParticipant a, MdParticipant b) {
          if (a.isCurrentUser) {
            return -1;
          }
          if (b.isCurrentUser) {
            return 1;
          }
          return 0;
        },
      );

    return uniqueList.obs;
  }

  /// Previous participants
  RxList<MdPreviousRound> get previousRounds {
    final List<MdPreviousRound> list = (joinedInvitationData().previousRounds ??
        <MdPreviousRound>[])
      ..removeWhere((MdPreviousRound p) =>
          p.participants?.any((MdPreviousParticipant u) =>
              u.supbaseId == SupaBaseService.userId) ??
          false)
      ..removeWhere((MdPreviousRound p) =>
          p.participants == null || p.participants!.isEmpty);

    return list.obs;
  }

  /// Check if previous participants is empty
  RxBool get isAddedFromPreviousRound =>
      previousRounds().any((MdPreviousRound p) => p.isAdded == true).obs;

  /// Participants without current user
  RxList<MdParticipant> get participantsWithoutCurrentUser {
    final List<MdParticipant> list =
        (joinedInvitationData().participants ?? <MdParticipant>[])
            .where((MdParticipant participant) => !participant.isCurrentUser)
            .toList();

    final Map<String?, MdParticipant> uniqueMap = <String?, MdParticipant>{
      for (final MdParticipant p in list) p.userData?.supabaseId: p
    };

    return uniqueMap.values.toList().obs;
  }

  /// Seconds left for the timer
  RxInt secondsLeft = 0.obs;

  /// Current index for texts
  RxInt currentIndex = 0.obs;

  /// Timer for countdown
  Timer? timer;

  /// Timer for texts
  Timer? textsTimer;

  /// Indicates if all selfies are taken
  RxBool isTimesUp = false.obs;

  /// Indicates if processing
  RxBool isProcessing = false.obs;

  /// Is starting round
  RxBool isStartingRound = false.obs;

  /// Submitting selfie
  RxBool submittingSelfie = false.obs;

  /// Is invitation send
  RxBool isInvitationSend = false.obs;

  /// Socket IO repository
  final SocketIoRepo socketIoRepo = SocketIoRepo();

  /// Quick adds count
  RxInt get quickAddsCount {
    final List<MdPreviousRound> _r = previousRounds()
        .where((MdPreviousRound p) => p.isAdded == true)
        .toList();

    final List<MdPreviousParticipant> _ap = <MdPreviousParticipant>[];
    for (final MdPreviousRound pr in _r) {
      if (pr.participants != null) {
        for (final MdPreviousParticipant p in pr.participants!) {
          if (!_ap
              .any((MdPreviousParticipant e) => e.supbaseId == p.supbaseId)) {
            _ap.add(p);
          }
        }
      }
    }

    return _ap.length.obs;
  }

  /// Checks if the camera is initialized.
  RxList<String> preSelfieStrings = <String>[
    'Still fixing his hair 👀',
    'Adjusting her glasses 🤓',
    'Checking camera settings 📸',
    'Doing quick mack-up 💄',
    'Practicing smile 😏',
    'Flexing muscles 💪',
  ].obs;

  /// Get selfies
  RxBool get isCurrentUserSelfieTaken {
    final MdParticipant? currentUser = participants().firstWhereOrNull(
        (MdParticipant participant) => participant.isCurrentUser);

    if (currentUser == null) {
      return false.obs;
    }

    return (currentUser.selfieUrl != null && currentUser.selfieUrl!.isNotEmpty)
        .obs;
  }

  /// Starts the timer from `roundJoinedEndAt`
  void startTimer({
    DateTime? endTime,
  }) {
    timer?.cancel();

    if (endTime == null) {
      secondsLeft.value = 0;
      isTimesUp(true);
      isProcessing(true);
    } else {
      final DateTime localEndTime = endTime.toLocal();

      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          final int diffInSeconds =
              localEndTime.difference(DateTime.now()).inSeconds;

          if (diffInSeconds <= 0) {
            secondsLeft.value = 0;
            isTimesUp(true);
            isProcessing(true);
            timer.cancel();
          } else {
            secondsLeft.value = diffInSeconds;
          }
        },
      );
    }
  }

  /// Stops the timer
  void stopTimer() {
    timer?.cancel();
  }

  ///  Sets up the timer for changing texts
  void setUpTextTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        currentIndex.value = (currentIndex() + 1) % preSelfieStrings.length;
        currentIndex.refresh();
      },
    );
  }

  /// On let go action
  void onLetGo() {
    final List<MdParticipant> _participants = participants()
        .where((MdParticipant participant) =>
            participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty)
        .toList();

    Get.toNamed(
      Routes.AI_CHOOSING,
      arguments: <String, dynamic>{
        'participants': _participants,
        'bet': joinedInvitationData().prompt ?? '',
      },
    );
  }
}
