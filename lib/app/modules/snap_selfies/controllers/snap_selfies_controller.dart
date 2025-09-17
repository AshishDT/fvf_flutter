import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/env_config.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_ai_result.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_previous_round.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/controllers/snap_selfie_keys_mixin.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/utils/app_config.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/api_service/init_api_service.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/app_loader.dart';
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

      loadPreviousRounds();

      if (joinedInvitationData().isFromInvitation ?? false) {
        DateTime? endAt = joinedInvitationData().roundJoinedEndAt;

        if (endAt != null && endAt.second > 2) {
          endAt = endAt.subtract(const Duration(seconds: 1));
        }

        isInvitationSend(true);

        _initWebSocket();

        if (!(joinedInvitationData().isViewOnly ?? false)) {
          startTimer(
            endTime: endAt,
          );
        }

        if (joinedInvitationData().isViewOnly ?? false) {
          setUpTextTimer();
        }
      }

      getShareUri();
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
    final bool isViewOnly = joinedInvitationData().isViewOnly ?? false;

    final Map<String, dynamic> currentArgs = <String, dynamic>{
      'reason': isViewOnly ? 'Round failed' : 'Only you joined..',
      'round_id': joinedInvitationData().id,
      'is_host': isHost(),
      'sub_reason': isViewOnly
          ? 'Not enough participants joined to start round'
          : 'Go again with your friends',
      'self_participant': selfParticipant(),
      'participants_without_current_user': participantsWithoutCurrentUser(),
      'host_id': joinedInvitationData().host?.supabaseId,
      'prompt': joinedInvitationData().prompt,
      'is_view_only': isViewOnly,
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
      arguments: <String, dynamic>{
        'seconds_left': secondsLeft(),
        'prompt': joinedInvitationData().prompt,
      },
    )?.then(
      (dynamic result) {
        if (result != null && result is XFile) {
          submitSelfie(File(result.path));
        }
      },
    );
  }

  /// Get share uri
  Future<void> getShareUri() async {
    final String? _uri = await DeepLinkService.generateSlayInviteLink(
      title: joinedInvitationData().prompt ?? '',
      invitationId: joinedInvitationData().id ?? '',
      hostId: joinedInvitationData().host?.supabaseId ?? '',
    );

    if (_uri != null && _uri.isNotEmpty) {
      deepLinkUri(_uri);
      deepLinkUri.refresh();
    }
  }

  /// Share uri
  Future<void> shareUri({bool fromResend = false}) async {
    try {
      String? _invitationLink;

      if (deepLinkUri().isNotEmpty) {
        _invitationLink = deepLinkUri();
      } else {
        _invitationLink = await DeepLinkService.generateSlayInviteLink(
          title: joinedInvitationData().prompt ?? '',
          invitationId: joinedInvitationData().id ?? '',
          hostId: joinedInvitationData().host?.supabaseId ?? '',
        );
      }

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
        submittingSelfie(false);
        _fallBackToStartAgain();
        break;

      case RoundStatus.completed:
        _onRoundCompleted(data);
        break;

      default:
        break;
    }
  }

  /// On round completed
  void _onRoundCompleted(MdSocketData data) {
    isProcessing(false);
    submittingSelfie(false);
    socketIoRepo.disposeRoundUpdate();

    final DateTime? revealedAt = DateTime.tryParse(data.round?.revealAt ?? '');

    Get
      ..until(
        (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
      )
      ..toNamed(
        Routes.WINNER,
        arguments: <String, dynamic>{
          'result_data': MdAiResultData(
            revealAt: revealedAt,
            status: RoundStatus.completed,
            id: data.round?.id,
            host: joinedInvitationData().host,
            participants: data.round?.participants,
            prompt: joinedInvitationData().prompt,
            results: data.round?.results,
            crew: data.round?.crew,
            isViewOnly: joinedInvitationData().isViewOnly ?? false,
          ),
        },
      );
  }

  /// Handle processing round
  void _handleProcessingRound() {
    final List<MdParticipant> participantsWithSelfies = participants()
        .where((MdParticipant participant) =>
            participant.selfieUrl != null && participant.selfieUrl!.isNotEmpty)
        .toList();

    final bool canStartRound =
        participantsWithSelfies.length >= AppConfig.minSubmissions;

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
        setUpTextTimer();
        emitDate();
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
    if (quickAddsCount() > AppConfig.maxPart) {
      appSnackbar(
        message:
            'You can only add up to ${AppConfig.maxPart} friends at a time.',
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

    final RxList<MdPreviousRound> _rounds = previousRounds()
        .where((MdPreviousRound p) => p.isAdded == true)
        .toList()
        .obs;

    for (final MdPreviousRound _r in _rounds) {
      if (_r.participants != null) {
        for (final MdPreviousParticipant _p in _r.participants!) {
          if (!previousAddedParticipants.any((MdPreviousParticipant existing) =>
                  existing.supaBaseId == _p.supaBaseId) &&
              _p.supaBaseId != SupaBaseService.userId) {
            _p.isAdded = true;
            previousAddedParticipants.add(_p);
          }
        }
      }
    }
  }

  /// Add previous participants
  Future<void> addPreviousParticipants() async {
    final List<MdPreviousParticipant> toAdd = previousAddedParticipants()
        .where((MdPreviousParticipant p) => p.isAdded == true)
        .toList();
    if (toAdd.isEmpty) {
      await shareUri();
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

  /// On add/remove previous participant
  void onAddRemovePreviousParticipant(String s) {
    for (final MdPreviousParticipant pp in previousAddedParticipants) {
      if (pp.supaBaseId == s) {
        pp.isAdded = !(pp.isAdded ?? false);
      }
    }

    final List<MdPreviousParticipant> selected = previousAddedParticipants
        .where((MdPreviousParticipant p) => p.isAdded ?? false)
        .toList();

    if (selected.isEmpty) {
      previousAddedParticipants.clear();

      for (final MdPreviousRound round in previousRounds) {
        round.isAdded = false;
      }
      previousRounds.refresh();
    }

    previousAddedParticipants.refresh();
    previousRounds.refresh();
  }

  /// Get view only
  Future<void> shareViewOnlyLink() async {
    Loader.show();
    try {
      final String? _uri = await DeepLinkService.generateSlayInviteLink(
        title: joinedInvitationData().prompt ?? '',
        invitationId: joinedInvitationData().id ?? '',
        hostId: joinedInvitationData().host?.supabaseId ?? '',
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
