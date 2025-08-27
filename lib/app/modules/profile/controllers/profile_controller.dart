import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/models/md_join_invitation.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_highlight.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_loader.dart';

/// Profile Controller
class ProfileController extends GetxController with WidgetsBindingObserver {
  /// image
  Rx<File> image = File('').obs;

  /// User
  Rxn<MdProfile> profile = Rxn<MdProfile>();

  /// isLoading
  RxBool isLoading = false.obs;

  /// PageController
  PageController pageController = PageController(initialPage: 0);

  /// participantPageController
  PageController participantPageController = PageController(initialPage: 0);

  /// Participant
  RxList<MdParticipant> participants = <MdParticipant>[
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1551847812-f815b31ae67c?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8c2VsZmllfGVufDB8fDB8fHww',
      userData: RoundHost(
        username: 'Jane Doe',
      ),
    ),
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1522556189639-b150ed9c4330?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c2VsZmllfGVufDB8fDB8fHww',
      userData: RoundHost(
        username: 'Alice Smith',
      ),
    ),
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1688597168861-b2d5f521cca6?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHNlbGZpZXxlbnwwfHwwfHx8MA%3D%3D',
      userData: RoundHost(
        username: 'Emily Johnson',
      ),
    ),
    MdParticipant(
      selfieUrl:
          'https://images.unsplash.com/photo-1612000529646-f424a2aa1bff?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNlbGZpZXxlbnwwfHwwfHx8MA%3D%3D',
      userData: RoundHost(
        username: 'Sophia Williams',
      ),
    ),
  ].obs;

  /// isExposed
  RxBool isExposed = false.obs;

  /// Current rank
  RxInt currentRank = 0.obs;

  /// currentIndex
  RxInt currentIndex = 0.obs;

  /// On init
  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );
    super.onInit();
    getUser();
  }

  /// On close
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    nameInputFocusNode.dispose();
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (_prevBottomInset() > 0 && currentViewInsets == 0) {
      Future<void>.delayed(
        const Duration(seconds: 1),
        () {
          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
          }
        },
      );
    }

    _prevBottomInset.value = currentViewInsets;
  }

  /// isCurrentUser
  bool get isCurrentUser =>
      profile.value?.user?.supabaseId == SupaBaseService.userId;

  /// Observable to track keyboard visibility
  RxBool isKeyboardVisible = false.obs;

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Focus node for chat input field
  final FocusNode nameInputFocusNode = FocusNode();

  /// Text editing controller for chat input field
  TextEditingController nameInputController = TextEditingController();

  /// Pick Image Method
  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e, st) {
      logE('Error picking image: $e');
      logE(st);
      return null;
    }
  }

  /// highlightCards
  final List<MdHighlight> highlightCards = <MdHighlight>[
    MdHighlight.random(
      title: 'Most likely to start an OF?',
      subtitle: 'That no-nonsense stare made it obvious',
    ),
    MdHighlight.random(
      title: 'Will become president?',
      subtitle: 'All of the indications of a girl that knows how to lie',
    ),
    MdHighlight.random(
      title: 'Most serious?',
      subtitle: 'She’s never heard of smiling',
    ),
    MdHighlight.random(
      title: 'Is the best at XYZ?',
      subtitle: 'The reason why she won goes here!',
    ),
  ];

  /// Get User
  Future<void> getUser() async {
    try {
      isLoading(true);
      final MdProfile? _user = await ProfileApiRepo.getUser();
      if (_user != null) {
        log('User fetched: ${_user.toJson()}');
        profile(_user);
      }
    } on Exception catch (e, st) {
      isLoading(false);
      logE('Error getting user: $e');
      logE(st);
    } finally {
      isLoading(false);
    }
  }

  /// Update User
  Future<void> updateUser({
    String? profilePic,
    String? username,
  }) async {
    try {
      isLoading(true);
      final bool? _isUpdated = await ProfileApiRepo.updateUser(
        profilePic: profilePic,
        username: username,
      );
      if (_isUpdated != null) {
        await getUser();
        appSnackbar(
          message: 'Profile updated successfully',
          snackbarState: SnackbarState.success,
        );
      }
    } on Exception catch (e, st) {
      logE('Error getting user: $e');
      logE(st);
    } finally {
      isLoading(false);
    }
  }

  /// Upload File
  Future<void> uploadFile({
    required File pickedImage,
    required String folder,
  }) async {
    Loader.show();
    try {
      final String? _uploadedUrl =
          await APIService.uploadFile(file: pickedImage, folder: folder);
      if (_uploadedUrl != null) {
        Loader.dismiss();
        await updateUser(
          profilePic: _uploadedUrl,
        );
      }
    } on Exception catch (e) {
      logE('Error getting upload file: $e');
      image(File(''));
      Loader.dismiss();
    } finally {
      Loader.dismiss();
    }
  }

  /// nextPage
  void nextPage() {
    if (participantPageController.hasClients) {
      participantPageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// prevPage
  void prevPage() {
    if (participantPageController.hasClients) {
      participantPageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
