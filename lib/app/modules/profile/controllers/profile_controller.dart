import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/api_service/init_api_service.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
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
import '../models/md_profile_args.dart';

/// Profile Controller
class ProfileController extends GetxController with TimeLineMixin {
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

  /// Entered name
  RxString enteredName = ''.obs;

  /// MdProfileArgs
  MdProfileArgs args = MdProfileArgs(
    tag: '',
    userId: '',
    supabaseId: '',
  );

  /// On init
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments is MdProfileArgs) {
      final MdProfileArgs _args = Get.arguments as MdProfileArgs;

      args = _args;

      final bool isCurrentUser = _args.supabaseId == SupaBaseService.userId;

      getUser(
        args: _args,
      );

      getRounds(
        args: _args,
        isRefresh: true,
      );

      if (isCurrentUser) {
        getBadges();
        debounce(
          enteredName,
          (_) {
            if (enteredName.isNotEmpty) {
              final String trimmed = enteredName.trim();
              if (trimmed.length < 3 || trimmed.length > 24) {
                return;
              }
              updateUser(username: enteredName.value);
            }
          },
          time: 400.milliseconds,
        );
      }
    }
  }

  /// On close
  @override
  void onClose() {
    nameInputFocusNode.dispose();
    for (final PageController pc in roundInnerPageController.values) {
      pc.dispose();
    }
    roundInnerPageController.clear();
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
  }) async {
    try {
      final bool isCurrentUser = args?.supabaseId == SupaBaseService.userId;

      isLoading(true);

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
  Future<void> getRounds({
    bool isRefresh = false,
    MdProfileArgs? args,
  }) async {
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

      final bool isCurrentUser = args?.supabaseId == SupaBaseService.userId;

      final List<MdRound>? _rounds = await ProfileApiRepo.getRounds(
        skip: skip,
        limit: limit,
        userId: isCurrentUser ? null : args?.userId,
      );
      if (_rounds != null && _rounds.isNotEmpty) {
        rounds.addAll(_rounds);
        skip += _rounds.length;
        logI('Round fetched: ${rounds.length}');
      } else {
        hasMore(false);
      }

      for (int i = 0; i < rounds.length; i++) {
        ensureRoundControllers(i, rounds[i].results?.length ?? 0);
      }

      syncRoundExposureFromAccess();
    } on Exception catch (e, st) {
      isRoundsLoading(false);
      logE('Error getting participants: $e');
      logE(st);
    } finally {
      isRoundsLoading(false);
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
