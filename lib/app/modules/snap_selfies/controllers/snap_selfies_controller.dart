import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/env_config.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
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
    Get
      ..until(
        (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      )
      ..toNamed(
        Routes.FAILED_ROUND,
        arguments: <String, dynamic>{
          'reason': 'Not enough selfies taken to start the round!',
          'round': MdRound(
            createdAt:
                DateTime.tryParse(joinedInvitationData().createdAt ?? ''),
            isActive: joinedInvitationData().isActive,
            isDeleted: joinedInvitationData().isDeleted,
            status: RoundStatusX.fromString(joinedInvitationData().status ?? ''),
            participants: <MdParticipant>[],
            isCustomPrompt: joinedInvitationData().isCustomPrompt,
            updatedAt:
                DateTime.tryParse(joinedInvitationData().updatedAt ?? ''),
            host: joinedInvitationData().host,
            id: joinedInvitationData().id,
            prompt: joinedInvitationData().prompt,
            roundJoinedEndAt: joinedInvitationData().roundJoinedEndAt,
          ),
          'sub_reason': ' Please ask your friends to join again.',
        },
      );
  }

  /// Stops the timer
  void stopTimer() {
    _timer?.cancel();
  }

  /// Checks if the camera is initialized.
  final List<String> texts = <String>[
    'Clark is still fixing his hair 👀',
    'Lois is adjusting her glasses 🤓',
    'Jimmy is checking his camera settings 📸',
    'Perry is doing quick mack-up 💄',
    'Lex is practicing his smile 😏',
    'Superman is flexing his muscles 💪',
  ];

  ///  Sets up the timer for changing texts
  void setUpTextTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (Timer timer) {
        currentIndex.value = (currentIndex() + 1) % texts.length;
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
        SharePlus.instance.share(
          ShareParams(
            uri: uri,
            title: 'Slay',
            subject: 'Slay Invitation',
          ),
        ),
      );
    } on Exception {
      logE('Error sharing invitation link');
    }
  }

  /// Socket IO data parser
  void socketIoDataParser(MdSocketData updatedData) {
    if (updatedData.round?.participants != null &&
        (updatedData.round?.participants?.isNotEmpty ?? false)) {
      joinedInvitationData().participants = updatedData.round?.participants;
      joinedInvitationData.refresh();
      participants.refresh();
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

      logWTF('Uploaded file name: $_fileName');

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
}
