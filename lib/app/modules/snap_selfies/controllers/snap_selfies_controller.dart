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
import 'package:fvf_flutter/app/modules/create_bet/models/md_previous_round.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/controllers/snap_selfie_keys_mixin.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../models/md_socket_io_response.dart';
import '../repositories/snap_selfie_api_repo.dart';

/// Snap Selfies Controller
class SnapSelfiesController extends GetxController
    with WidgetsBindingObserver, SnapSelfieKeysMixin {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      joinedInvitationData.value = Get.arguments as MdJoinInvitation;
      joinedInvitationData.refresh();
      participants.refresh();
      getPreSelfieStrings();

      if (joinedInvitationData().isFromInvitation ?? false) {
        DateTime? endAt = joinedInvitationData().roundJoinedEndAt;

        if (endAt != null && endAt.second > 2) {
          endAt = endAt.subtract(const Duration(seconds: 1));
        }

        _initWebSocket();

        startTimer(
          endTime: endAt,
        );
      }
    }

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
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

  /// Initialize WebSocket connection and listeners
  void _initWebSocket() {
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
    textsTimer?.cancel();
    socketIoRepo.dispose();
    stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    nameInputFocusNode.dispose();
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (prevBottomInset() > 0 && currentViewInsets == 0) {
      if (Get.isOverlaysOpen) {
        Get.back();
      }
    }

    prevBottomInset.value = currentViewInsets;
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

  /// Share uri
  Future<void> shareUri({bool fromResend = false}) async {
    try {
      final String? _invitationLink =
          await DeepLinkService.generateSlayInviteLink(
        title: joinedInvitationData().prompt ?? '',
        invitationId: joinedInvitationData().id ?? '',
        hostId: joinedInvitationData().host?.supabaseId ?? '',
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
          (ShareResult result) async {
            if (!fromResend) {
              await startRound();
            }
          },
        ),
      );
    } on Exception {
      logE('Error sharing invitation link');
    }
  }

  /// Check and add name wiggle
  void _checkAddNameWiggle() {
    if (selfParticipant().userData?.username == null ||
        (selfParticipant().userData?.username?.isEmpty ?? true)) {
      Future<void>.delayed(
        const Duration(seconds: 2),
        () {
          shouldWiggleAddName(true);
        },
      );
    } else {
      shouldWiggleAddName(false);
    }
  }

  void _checkSnapPickWiggle() {
    if (selfParticipant().selfieUrl == null ||
        (selfParticipant().selfieUrl?.isEmpty ?? true)) {
      Future<void>.delayed(
        const Duration(seconds: 2),
        () {
          shouldWiggleSnapPick(true);
        },
      );
    } else {
      shouldWiggleSnapPick(false);
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
      final Map<String, MdParticipant> uniqueParticipants =
          <String, MdParticipant>{};

      for (final MdParticipant participant in data.round!.participants!) {
        final String? supabaseId = participant.userData?.supabaseId;
        if (supabaseId == null) {
          continue;
        }

        if (!uniqueParticipants.containsKey(supabaseId)) {
          uniqueParticipants[supabaseId] = participant;
        } else {
          final MdParticipant existing = uniqueParticipants[supabaseId]!;

          if ((existing.selfieUrl == null || existing.selfieUrl!.isEmpty) &&
              (participant.selfieUrl != null &&
                  participant.selfieUrl!.isNotEmpty)) {
            uniqueParticipants[supabaseId] = participant;
          }
        }
      }

      joinedInvitationData().participants = uniqueParticipants.values.toList();

      if (data.round?.roundJoinedEndAt != null) {
        joinedInvitationData().roundJoinedEndAt = data.round?.roundJoinedEndAt;
        joinedInvitationData.refresh();
        participants.refresh();

        startTimer(
          endTime: joinedInvitationData().roundJoinedEndAt,
        );
      }

      _checkAddNameWiggle();
      _checkSnapPickWiggle();
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

  /// Start round
  Future<void> startRound() async {
    isStartingRound(true);
    try {
      final MdRound? _round = await SnapSelfieApiRepo.startRound(
        roundId: joinedInvitationData().id ?? '',
      );

      if (_round != null) {
        joinedInvitationData().roundJoinedEndAt = _round.roundJoinedEndAt;
        joinedInvitationData.refresh();

        _initWebSocket();

        isInvitationSend(true);

        startTimer(
          endTime: _round.roundJoinedEndAt,
        );
      }
    } finally {
      isStartingRound(false);
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

  /// On add previous participant
  void onAddPreviousRound(String roundId) {
    if (quickAddsCount() > 8) {
      appSnackbar(
        message: 'You can only add up to 8 friends at a time.',
        snackbarState: SnackbarState.info,
      );
      return;
    }

    for (final MdPreviousRound p in previousRounds()) {
      if (p.id == roundId) {
        if (p.isAdded == true) {
          p.isAdded = false;
        } else {
          p.isAdded = true;
        }
      }
      previousRounds.refresh();
      joinedInvitationData.refresh();
    }
  }

  /// Add previous participants
  Future<void> addPreviousParticipants() async {
    final List<MdPreviousRound> toAddRounds =
        previousRounds.where((MdPreviousRound p) => p.isAdded == true).toList();

    final List<MdPreviousParticipant> toAdd = <MdPreviousParticipant>[];
    for (final MdPreviousRound round in toAddRounds) {
      if (round.participants != null) {
        for (final MdPreviousParticipant p in round.participants!) {
          if (!toAdd.any((MdPreviousParticipant existing) =>
                  existing.supbaseId == p.supbaseId) &&
              p.supbaseId != SupaBaseService.userId) {
            toAdd.add(p);
          }
        }
      }
    }

    if (toAdd.isEmpty) {
      await shareUri();
      return;
    }

    if (toAdd.length < 2) {
      appSnackbar(
        message: 'Please add at least 2 friends to start the round.',
        snackbarState: SnackbarState.warning,
      );
      return;
    }

    final List<String> userIds = toAdd
        .where((MdPreviousParticipant p) => p.id != null && p.id!.isNotEmpty)
        .map((MdPreviousParticipant p) => p.id!)
        .toList();

    final bool? _isAdded = await SnapSelfieApiRepo.addParticipants(
      roundId: joinedInvitationData().id ?? '',
      userIds: userIds,
    );

    if (!(_isAdded ?? false)) {
      return;
    }

    await startRound();
  }
}
