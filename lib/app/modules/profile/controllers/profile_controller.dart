import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
import 'package:fvf_flutter/app/modules/profile/controllers/timelines_mixin.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_badge.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_profile.dart';
import 'package:fvf_flutter/app/modules/profile/models/md_user_rounds.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/profile_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/global_keys.dart';
import '../../claim_phone/controllers/phone_claim_service.dart';
import '../../claim_phone/repositories/phone_check_eligibility_checker.dart';
import '../models/md_profile_args.dart';
import '../repositories/edit_profile_sheet_repo.dart';

/// Profile Controller
class ProfileController extends GetxController
    with TimeLineMixin, WidgetsBindingObserver {
  /// image
  Rx<File> image = File('').obs;

  /// User
  Rx<MdProfile> profile = MdProfile().obs;

  /// isLoading
  RxBool isLoading = false.obs;

  /// isRoundsLoading
  RxBool isRoundsLoading = false.obs;

  /// Rounds list
  @override
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
  @override
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

  /// MdProfileArgs
  MdProfileArgs args = MdProfileArgs(
    tag: '',
    userId: '',
  );

  /// On init
  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );

    setupPageController();

    if (Get.arguments is MdProfileArgs) {
      final MdProfileArgs _args = Get.arguments as MdProfileArgs;

      args = _args;

      getUser(
        args: _args,
      );

      getRounds(
        args: _args,
        isRefresh: true,
      );
      getBadges(
        args: _args,
      );
    }
  }

  @override
  void onReady() {
    noScreenshot.screenshotOn();
    super.onReady();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (_prevBottomInset() > 0 && currentViewInsets == 0) {
      Future<void>.microtask(
        () {
          if (EditProfileSheetRepo.isSheetOpen()) {
            Get.close(0);
          }
        },
      );
    }

    _prevBottomInset.value = currentViewInsets;
  }

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Setup page controller
  void setupPageController() {
    roundPageController = PageController();
  }

  /// On close
  @override
  void onClose() {
    for (final PageController pc in roundInnerPageController.values) {
      if (pc.hasClients) {
        pc.dispose();
      }
    }
    roundInnerPageController.clear();
    WidgetsBinding.instance.removeObserver(this);
    noScreenshot.screenshotOn();
    super.onClose();
  }

  /// isCurrentUser
  bool get isCurrentUser => profile.value.user?.id == UserProvider.userId;

  /// Text editing controller for chat input field
  TextEditingController nameInputController = TextEditingController();

  /// Badges
  RxList<MdBadge> badges = <MdBadge>[].obs;

  /// Current badge
  Rx<MdBadge> currentBadge = MdBadge().obs;

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

  /// Get User
  Future<void> getUser({
    MdProfileArgs? args,
    bool showLoader = true,
  }) async {
    try {
      final bool isCurrentUser = args?.userId == UserProvider.userId;

      if (showLoader) {
        isLoading(true);
      }

      final MdProfile? _user = await ProfileApiRepo.getUser(
        userId: isCurrentUser ? null : args?.userId,
      );
      if (_user != null) {
        profile(_user);
        final String? userAuthToken = UserProvider.authToken;

        currentBadge(
          _user.user?.badge,
        );
        currentBadge.refresh();

        roundData(_user.round);
        roundData.refresh();

        if (isCurrentUser) {
          UserProvider.onLogin(
            user: profile().user!,
            userAuthToken: userAuthToken ?? '',
          );

          final int totalRounds = profile().round?.totalRound ?? 0;

          final bool shouldShow =
              await PhoneClaimChecker.shouldShowSheet(
            totalRounds: totalRounds,
          );

          final bool hasClaimed = profile().user?.isClaim ?? false;

          if (shouldShow && !hasClaimed) {
            await PhoneClaimService.open().then(
              (_) {
                PhoneClaimChecker.markDeclined(
                  currentRoundCount: totalRounds,
                );
              },
            );
          }
        }
      }
    } on Exception catch (e, st) {
      if (showLoader) {
        isLoading(false);
      }

      logE('Error getting user: $e');
      logE(st);
    } finally {
      if (showLoader) {
        isLoading(false);
      }
    }
  }

  /// Update User
  Future<void> updateUser({
    String? profilePic,
    String? username,
    bool showLoader = true,
  }) async {
    if ((username?.trim().isEmpty ?? true) && (profilePic?.isEmpty ?? true)) {
      return;
    }

    final String normalizedCurrent =
        profile().user?.username?.trim().toLowerCase() ?? '';
    final String normalizedNew = username?.trim().toLowerCase() ?? '';

    if (normalizedCurrent == normalizedNew && (profilePic?.isEmpty ?? true)) {
      return;
    }

    try {
      if (showLoader) {
        isLoading(true);
      }

      final bool updated = await ProfileApiRepo.updateUser(
        profilePic: profilePic,
        username: username,
      );

      if (updated) {
        await getUser(
          args: args,
          showLoader: showLoader,
        );
        await getRounds(
          args: args,
          isRefresh: true,
          showLoader: showLoader,
        );
      }
    } on Exception catch (e, st) {
      logE('Error updating user: $e');
      logE(st);
      if (showLoader) {
        isLoading(false);
      }
    } finally {
      if (showLoader) {
        isLoading(false);
      }
    }
  }

  /// Upload File
  Future<void> uploadFile({
    required File pickedImage,
    required String folder,
    bool showLoader = true,
  }) async {
    if (showLoader) {
      Loader.show();
    }

    try {
      final String? _uploadedUrl =
          await APIService.uploadFile(file: pickedImage, folder: folder);
      if (_uploadedUrl != null) {
        if (showLoader) {
          Loader.dismiss();
        }
        await updateUser(
          showLoader: showLoader,
          profilePic: _uploadedUrl,
        );
      }
    } on DioException catch (e) {
      logE('Error getting upload file: $e');
      image(File(''));
      if (showLoader) {
        Loader.dismiss();
      }
      appSnackbar(
        message: 'Profile upload failed, please try again.',
        snackbarState: SnackbarState.danger,
      );
    } finally {
      if (showLoader) {
        Loader.dismiss();
      }
    }
  }

  /// Get Rounds
  Future<void> getRounds({
    bool isRefresh = false,
    MdProfileArgs? args,
    bool showLoader = true,
  }) async {
    if (isRoundsLoading()) {
      return;
    }

    try {
      if (isRefresh) {
        if (showLoader) {
          isRoundsLoading(true);
        }

        skip = 0;
        hasMore(true);
        rounds.clear();
      }

      final bool isCurrentUser = args?.userId == UserProvider.userId;

      final MdUserRounds? _roundsData = await ProfileApiRepo.getRounds(
        skip: skip,
        limit: limit,
        userId: isCurrentUser ? null : args?.userId,
      );

      final List<MdRound> _rounds = _roundsData?.rounds ?? <MdRound>[];

      if (_rounds.isNotEmpty) {
        rounds.addAll(_rounds);
        skip += _rounds.length;

        if (rounds.length >= (_roundsData?.total ?? 0)) {
          hasMore(false);
        }
      } else {
        hasMore(false);
      }

      for (int i = 0; i < rounds.length; i++) {
        ensureRoundControllers(i, rounds[i].results?.length ?? 0);
      }

      syncRoundExposureFromAccess(
        userId: isCurrentUser ? null : args?.userId,
      );
    } on Exception catch (e, st) {
      if (showLoader) {
        isRoundsLoading(false);
      }

      logE('Error getting participants: $e');
      logE(st);
    } finally {
      if (showLoader) {
        isRoundsLoading(false);
      }
    }
  }

  /// Get Badges
  Future<void> getBadges({
    MdProfileArgs? args,
  }) async {
    try {
      final bool isCurrentUser = args?.userId == UserProvider.userId;

      final List<MdBadge>? _badges = await ProfileApiRepo.getBadges(
        userId: isCurrentUser ? null : args?.userId,
      );

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

  /// Change Profile Picture
  Future<void> changeProfile() async {
    final File? pickedImage = await pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image(pickedImage);
      await uploadFile(
        pickedImage: pickedImage,
        folder: 'profile',
        showLoader: false,
      );
    }
  }

  /// On add name
  void onAddName() {
    final String trimmed = nameInputController.text.trim();

    if (trimmed.isEmpty) {
      return;
    }

    if (trimmed.length < 3 || trimmed.length > 24) {
      appSnackbar(
        message: 'Name must be between 3 and 24 characters.',
        snackbarState: SnackbarState.danger,
      );
      return;
    }
    updateUser(
      username: trimmed,
    );
  }
}
