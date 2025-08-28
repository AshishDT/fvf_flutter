import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/env_config.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_socket_io_response.dart';
import '../repositories/snap_selfie_api_repo.dart';
import '../../../data/remote/socket_io_repo.dart';

/// Snap Selfies Controller
class SnapSelfiesController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      joinedInvitationData.value = Get.arguments as MdJoinInvitation;
      joinedInvitationData.refresh();
      participants.refresh();

      startTimer();
      getPreSelfieStrings();
    }

    socketIoRepo
      ..initSocket(url: EnvConfig.socketUrl)
      ..listenForDateEvent(
        (dynamic data) {
          log('🎯 Controller got update: $data');
          log('Current user Id : ${SupaBaseService.userId}');
          final MdSocketData updatedData = MdSocketData.fromJson(data);

          socketIoDataParser(updatedData);
        },
      )
      ..startAutoEmit(
        <String, dynamic>{
          'user_id': SupaBaseService.userId,
          'round_id': joinedInvitationData().id,
        },
      );

    super.onInit();
  }

  /// Call emit with custom payload
  void emitDate() {
    final Map<String, dynamic> payload = <String, dynamic>{
      'user_id': SupaBaseService.userId,
      'round_id': joinedInvitationData().id,
    };
    socketIoRepo.emitGetDate(payload);
  }

  /// On ready
  @override
  void onReady() {
    super.onReady();
  }

  /// On close
  @override
  void onClose() {
    stopTimer();
    _textsTimer?.cancel();
    socketIoRepo.dispose();
    stopTimer();
    super.onClose();
  }

  /// Joined invitation data
  Rx<MdJoinInvitation> joinedInvitationData = MdJoinInvitation().obs;

  /// Check if current user is host
  RxBool get isHost =>
      (joinedInvitationData().host?.supabaseId == SupaBaseService.userId).obs;

  /// Participants
  RxList<MdParticipant> get participants {
    final List<MdParticipant> list =
        joinedInvitationData().participants ?? <MdParticipant>[]
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

    return list.obs;
  }

  /// Seconds left for the timer
  RxInt secondsLeft = 300.obs;

  /// Timer for countdown
  Timer? _timer;

  /// Current index for texts
  RxInt currentIndex = 0.obs;

  /// Timer for texts
  Timer? _textsTimer;

  /// Indicates if all selfies are taken
  RxBool isTimesUp = false.obs;

  /// Submitting selfie
  RxBool submittingSelfie = false.obs;

  /// Is invitation send
  RxBool isInvitationSend = false.obs;

  /// Socket IO repository
  final SocketIoRepo socketIoRepo = SocketIoRepo();

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
  void startTimer() {
    _timer?.cancel();

    final DateTime? endTime = joinedInvitationData().roundJoinedEndAt;

    if (endTime == null) {
      secondsLeft.value = 300;
    } else {
      final DateTime localEndTime = endTime.toLocal();

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          final int diffInSeconds =
              localEndTime.difference(DateTime.now()).inSeconds;

          if (diffInSeconds <= 0) {
            secondsLeft.value = 0;
            _handleTimeUp();
            timer.cancel();
          } else {
            secondsLeft.value = diffInSeconds;
          }
        },
      );
    }
  }

  /// Handles what happens when timer finishes
  void _handleTimeUp() {
    final List<MdParticipant> participantsWithSelfies = participants()
        .where((MdParticipant participant) =>
            participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty)
        .toList();

    final bool canStartRound = participantsWithSelfies.isNotEmpty &&
        participantsWithSelfies.length >= 2;

    if (canStartRound) {
      isTimesUp(true);
      socketIoRepo.disposeRoundUpdate();
      onLetGo();
    } else {
      _fallBackToStartAgain();
    }
  }

  /// Fallback to start again
  void _fallBackToStartAgain() {
    final Map<String, dynamic> currentArgs = <String, dynamic>{
      'reason': 'Not enough selfies taken to start the round!',
      'round_id': joinedInvitationData().id,
      'is_host': isHost(),
      'sub_reason': ' Please ask your friends to join again.',
    };

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Get.offNamed(
          Routes.FAILED_ROUND,
          arguments: currentArgs,
        );
      },
    );
  }

  /// Stops the timer
  void stopTimer() {
    _timer?.cancel();
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

  ///  Sets up the timer for changing texts
  void setUpTextTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        currentIndex.value = (currentIndex() + 1) % preSelfieStrings.length;
        currentIndex.refresh();
      },
    );
  }

  /// Handles the action when the user snaps a selfie
  Future<void> onSnapSelfie() async {
    await Get.toNamed(
      Routes.CAMERA,
      arguments: secondsLeft(),
    )?.then(
      (dynamic result) {
        if (result != null && result is XFile) {
          submitSelfie(File(result.path));
        }
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

  /// Share uri
  Future<void> shareUri() async {
    try {
      final String? _invitationLink =
          await DeepLinkService.generateSlayInviteLink(
        title: joinedInvitationData().prompt ?? '',
        invitationId: joinedInvitationData().id ?? '',
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
        )
            .then(
          (ShareResult result) {
            isInvitationSend(true);
          },
        ),
      );
    } on Exception {
      logE('Error sharing invitation link');
    }
  }

  /// Socket IO data parser
  void socketIoDataParser(MdSocketData updatedData) {
    if (updatedData.error != null && updatedData.error!.isNotEmpty) {
      Get.until(
        (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      );
      appSnackbar(
        message: updatedData.error!,
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    if (updatedData.round?.participants != null &&
        (updatedData.round?.participants?.isNotEmpty ?? false)) {
      joinedInvitationData().participants = updatedData.round?.participants;
      if (updatedData.round?.roundJoinedEndAt != null) {
        joinedInvitationData().roundJoinedEndAt =
            updatedData.round?.roundJoinedEndAt;
        joinedInvitationData.refresh();
        participants.refresh();

        startTimer();
      }
    }
  }

  /// Upload selfie
  Future<String?> uploadSelfie({
    required File pickedImage,
    required String folder,
  }) async {
    try {
      final String? _imagePath =
          await APIService.uploadFile(file: pickedImage, folder: folder);
      if (_imagePath != null) {
        return _imagePath;
      }

      return null;
    } on Exception catch (e) {
      logE('Error getting upload file: $e');
      return null;
    }
  }

  /// Submit selfie
  Future<void> submitSelfie(File file) async {
    submittingSelfie(true);
    try {
      final String? _fileName =
          await uploadSelfie(pickedImage: file, folder: 'selfie');

      if (_fileName == null || _fileName.isEmpty) {
        appSnackbar(
          message: 'Failed to upload selfie. Please try again.',
          snackbarState: SnackbarState.danger,
        );
        return;
      }

      final bool? isSuccess = await SnapSelfieApiRepo.submitSelfie(
        roundId: joinedInvitationData().id ?? '',
        fileName: _fileName,
      );

      if (isSuccess == true) {
        emitDate();
        setUpTextTimer();
        appSnackbar(
          message: 'Selfie submitted successfully!',
          snackbarState: SnackbarState.success,
        );
      }
    } finally {
      submittingSelfie(false);
    }
  }

  /// Get pre-selfie strings
  Future<void> getPreSelfieStrings() async {
    try {
      final List<String>? _preSelfieActions =
          await SnapSelfieApiRepo.getPreSelfieActions();

      if (_preSelfieActions?.isNotEmpty ?? false) {
        preSelfieStrings.clear();
        preSelfieStrings(_preSelfieActions);
        preSelfieStrings.refresh();
      }
    } finally {
      submittingSelfie(false);
    }
  }
}
