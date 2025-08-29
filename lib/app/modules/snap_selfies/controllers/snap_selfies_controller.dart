import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/env_config.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
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
class SnapSelfiesController extends GetxController with WidgetsBindingObserver {
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

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );
    super.onInit();

    // Debounce enteredName updates
    debounce(
      enteredName,
      (_) {
        if (enteredName.isNotEmpty) {
          updateUser(username: enteredName.value);
        }
      },
      time: 400.milliseconds,
    );
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
    WidgetsBinding.instance.removeObserver(this);
    nameInputFocusNode.dispose();
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (_prevBottomInset() > 0 && currentViewInsets == 0) {
      if (Get.isOverlaysOpen) {
        Get.back();
      }
    }

    _prevBottomInset.value = currentViewInsets;
  }

  /// Observable to track keyboard visibility
  RxBool isKeyboardVisible = false.obs;

  /// Entered name
  RxString enteredName = ''.obs;

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Focus node for name input field
  final FocusNode nameInputFocusNode = FocusNode();

  /// Text editing controller for name input field
  TextEditingController nameInputController = TextEditingController();

  /// User profile
  Rx<MdProfile> profile = MdProfile().obs;

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

  /// Participants without current user
  RxList<MdParticipant> get participantsWithoutCurrentUser {
    final List<MdParticipant> list = joinedInvitationData()
            .participants
            ?.where(
              (MdParticipant participant) => !participant.isCurrentUser,
            )
            .toList() ??
        <MdParticipant>[];
    return list.obs;
  }

  /// Seconds left for the timer
  RxInt secondsLeft = 0.obs;

  /// Timer for countdown
  Timer? _timer;

  /// Current index for texts
  RxInt currentIndex = 0.obs;

  /// Timer for texts
  Timer? _textsTimer;

  /// Indicates if all selfies are taken
  RxBool isTimesUp = false.obs;

  /// Indicates if processing
  RxBool isProcessing = false.obs;

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

  /// Fallback to start again
  void _fallBackToStartAgain() {
    final Map<String, dynamic> currentArgs = <String, dynamic>{
      'reason': 'Only you joined..',
      'round_id': joinedInvitationData().id,
      'is_host': isHost(),
      'sub_reason': 'Go again with your friends',
      'self_participant': selfParticipant(),
      'participants_without_current_user': participantsWithoutCurrentUser(),
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
    if (_hasError(updatedData)) {
      return;
    }

    _updateParticipants(updatedData);
    _handleRoundStatus(updatedData);
  }

  /// Check if there is an error in the data
  bool _hasError(MdSocketData data) {
    if (data.error != null && data.error!.isNotEmpty) {
      Get.until(
        (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      );

      appSnackbar(
        message: data.error!,
        snackbarState: SnackbarState.danger,
      );
      return true;
    }
    return false;
  }

  /// Update participants
  void _updateParticipants(MdSocketData data) {
    if (data.round?.participants != null &&
        (data.round?.participants?.isNotEmpty ?? false)) {
      joinedInvitationData().participants = data.round?.participants;

      if (data.round?.roundJoinedEndAt != null) {
        joinedInvitationData().roundJoinedEndAt = data.round?.roundJoinedEndAt;
        joinedInvitationData.refresh();
        participants.refresh();
      }
    }
  }

  /// Handle round status
  void _handleRoundStatus(MdSocketData data) {
    final RoundStatus? status = data.round?.status;

    switch (status) {
      case RoundStatus.processing:
        isProcessing(true);
        _handleProcessingRound();
        break;

      case RoundStatus.failed:
        _fallBackToStartAgain();
        break;

      default:
        break;
    }
  }

  /// Handle processing round
  void _handleProcessingRound() {
    final List<MdParticipant> participantsWithSelfies = participants()
        .where((MdParticipant participant) =>
            participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty)
        .toList();

    final bool canStartRound = participantsWithSelfies.length >= 2;

    if (canStartRound) {
      socketIoRepo.disposeRoundUpdate();
      onLetGo();
    } else {
      _fallBackToStartAgain();
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
          message: 'Snap submitted successfully!',
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

  /// Update User
  Future<void> updateUser({
    String? username,
  }) async {
    try {
      final bool? _isUpdated = await ProfileApiRepo.updateUser(
        username: username,
      );
      if (_isUpdated != null) {
        await getUser();
        // appSnackbar(
        //   message: 'Username updated successfully',
        //   snackbarState: SnackbarState.success,
        // );
      }
    } on Exception catch (e, st) {
      logE('Error getting update name: $e');
      logE(st);
    } finally {}
  }

  /// User profile
  Future<void> getUser() async {
    try {
      final MdProfile? _user = await ProfileApiRepo.getUser();
      if (_user != null) {
        profile(_user);

        final String? userAuthToken = UserProvider.authToken;

        UserProvider.onLogin(
          user: profile().user!,
          userAuthToken: userAuthToken ?? '',
        );
      }
    } on Exception catch (e, st) {
      logE('Error getting user: $e');
      logE(st);
    }
  }
}
