import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/profile/enums/subscription_enum.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_badge.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_highlight.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_user_rounds.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
import 'package:fvf_flutter/app/modules/winner/repositories/winner_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../utils/app_loader.dart';

/// Profile Controller
class ProfileController extends GetxController {
  /// image
  Rx<File> image = File('').obs;

  /// User
  Rx<MdProfile> profile = MdProfile().obs;

  /// isLoading
  RxBool isLoading = false.obs;

  /// isRoundsLoading
  RxBool isRoundsLoading = false.obs;

  /// participants list
  RxList<MdRound> rounds = <MdRound>[].obs;

  /// Skip
  int skip = 0;

  /// Limit
  final int limit = 10;

  /// Has more
  RxBool hasMore = true.obs;

  /// PageController
  PageController pageController = PageController(initialPage: 0);

  /// RoundPageController
  late PageController roundPageController;

  /// Current round
  RxInt currentRound = 0.obs;

  /// currentIndex
  RxInt currentIndex = 0.obs;

  /// Packages
  RxList<StoreProduct> packages = <StoreProduct>[].obs;

  /// isRoundSubLoading
  RxBool isRoundSubLoading = false.obs;

  /// isWeeklySubLoading
  RxBool isWeeklySubLoading = false.obs;

  /// animatedIndex
  RxInt animatedIndex = 0.obs;

  /// Entered name
  RxString enteredName = ''.obs;

  /// On init
  @override
  void onInit() {
    super.onInit();
    getUser();
    getRounds(isRefresh: true);
    getBadges();

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

  /// On close
  @override
  void onClose() {
    nameInputFocusNode.dispose();
    super.onClose();
  }

  /// isCurrentUser
  bool get isCurrentUser =>
      profile.value.user?.supabaseId == SupaBaseService.userId;

  /// Focus node for chat input field
  final FocusNode nameInputFocusNode = FocusNode();

  /// Text editing controller for chat input field
  TextEditingController nameInputController = TextEditingController();

  /// Badges
  RxList<MdBadge> badges = <MdBadge>[].obs;

  /// Current badge
  Rx<MdBadge?> get currentBadge {
    final MdBadge? _badge = badges.firstWhereOrNull(
      (MdBadge element) => element.current == true && element.earned == true,
    );

    return _badge.obs;
  }

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
        final String? userAuthToken = UserProvider.authToken;

        UserProvider.onLogin(
          user: profile().user!,
          userAuthToken: userAuthToken ?? '',
        );
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
    if ((username?.trim().isEmpty ?? true) &&
        (profilePic?.trim().isEmpty ?? true)) {
      return;
    }

    try {
      isLoading(true);
      final bool _isUpdated = await ProfileApiRepo.updateUser(
        profilePic: profilePic,
        username: username,
      );
      if (_isUpdated) {
        await getUser();
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
    } on DioException catch (e) {
      logE('Error getting upload file: $e');
      image(File(''));
      Loader.dismiss();
      appSnackbar(
        message: 'Profile upload failed, please try again.',
        snackbarState: SnackbarState.danger,
      );
    } finally {
      Loader.dismiss();
    }
  }

  /// Get Rounds
  Future<void> getRounds({bool isRefresh = false}) async {
    if (isRoundsLoading()) {
      return;
    }
    try {
      if (isRefresh) {
        isRoundsLoading(true);
        skip = 0;
        hasMore(true);
        rounds.clear();
        roundPageController = PageController();
      }
      final List<MdRound>? _rounds =
          await ProfileApiRepo.getRounds(skip: skip, limit: limit);
      if (_rounds != null && _rounds.isNotEmpty) {
        rounds.addAll(_rounds);
        skip += _rounds.length;
        logI('Round fetched: ${rounds.length}');
      } else {
        hasMore(false);
      }
    } on Exception catch (e, st) {
      isRoundsLoading(false);
      logE('Error getting participants: $e');
      logE(st);
    } finally {
      isRoundsLoading(false);
    }
  }

  /// Next page navigation
  void nextPage() {
    if (roundPageController.hasClients) {
      final int nextIndex = currentRound() + 1;

      if (nextIndex < rounds.length) {
        roundPageController.animateToPage(
          nextIndex,
          duration: 300.milliseconds,
          curve: Curves.easeInOut,
        );
        currentRound(nextIndex);
        if (nextIndex >= rounds.length - 2 && hasMore()) {
          getRounds();
        }
      }
    }
  }

  /// Previous page navigation
  void prevPage() {
    if (roundPageController.hasClients) {
      final int prevIndex = currentRound() - 1;
      if (prevIndex >= 0) {
        roundPageController.animateToPage(
          prevIndex,
          duration: 300.milliseconds,
          curve: Curves.easeInOut,
        );
        currentRound(prevIndex);
      }
    }
  }

  /// Round Subscription
  Future<bool> roundSubscription({
    required String roundId,
    required String paymentId,
    required SubscriptionPlanEnum type,
  }) async {
    try {
      type == SubscriptionPlanEnum.ONE_TIME
          ? isRoundSubLoading(true)
          : isWeeklySubLoading(true);
      const bool _isPurchase = true;

      // TODO - Add reveue cat service
      if (_isPurchase) {
        return _isPurchase;
      }
      return false;
    } on Exception catch (e, st) {
      type == SubscriptionPlanEnum.ONE_TIME
          ? isRoundSubLoading(false)
          : isWeeklySubLoading(false);
      logE('Error getting purchase: $e');
      logE(st);
      return false;
    } finally {
      type == SubscriptionPlanEnum.ONE_TIME
          ? isRoundSubLoading(false)
          : isWeeklySubLoading(false);
    }
  }

  /// Add reaction
  Future<void> addReaction({
    required String roundId,
    required String emoji,
    required String participantId,
  }) async {
    final bool? _isAdded = await WinnerApiRepo.addReaction(
      roundId: roundId,
      emoji: emoji,
      participantId: participantId,
    );

    if (_isAdded == true && rounds().isNotEmpty) {
      rounds()[currentRound()].reactions = emoji;
      rounds.refresh();
    } else {
      appSnackbar(
        message: 'Failed to add reaction. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    }
  }

  /// Get Badges
  Future<void> getBadges() async {
    try {
      final List<MdBadge>? _badges = await ProfileApiRepo.getBadges();

      if (_badges != null && _badges.isNotEmpty) {
        badges(_badges);
        badges.refresh();
      }
    } on Exception catch (e) {
      logE(
        'Error getting badges: $e',
      );
    }
  }
}
