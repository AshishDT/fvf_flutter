import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/store/local_store.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_bet.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/modules/create_bet/repositories/create_bet_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import '../../../data/enums/purchase_status.dart';
import '../../../data/local/user_provider.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/models/md_purchase_result.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../data/remote/notification_service/notification_actions.dart';
import '../../../data/remote/notification_service/notification_service.dart';
import '../../../data/remote/revenue_cat/revenue_cat_service.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/chat_field_sheet_repo.dart';
import '../../../utils/global_keys.dart';
import '../../profile/enums/subscription_enum.dart';
import '../../profile/models/md_profile.dart';
import '../../profile/repositories/profile_api_repo.dart';
import '../../rating/models/rating_state.dart';
import '../../rating/repositories/rating_repository.dart';
import '../../rating/repositories/rating_service.dart';
import '../models/md_can_create_bet.dart';
import '../models/md_participant.dart';
import '../widgets/slaying_sheet.dart';

/// Create Bet Controller
class CreateBetController extends GetxController with WidgetsBindingObserver {
  /// Scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// On init
  @override
  void onInit() {
    DeepLinkService.initBranchListener();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );

    _initNotificationClick();

    getBets();
    getUser();
    checkCanCreateRound();

    super.onInit();
  }

  /// On ready
  @override
  void onReady() {
    super.onReady();
  }

  /// On close
  @override
  void onClose() {
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (_prevBottomInset() > 0 && currentViewInsets == 0) {
      Future<void>.microtask(
        () {
          if (ChatFieldSheetRepo.isSheetOpen()) {
            Get.close(0);
          }
        },
      );
    }

    _prevBottomInset.value = currentViewInsets;
  }

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Entered bet
  RxString enteredBet = ''.obs;

  /// Text editing controller for chat input field
  TextEditingController messageInputController = TextEditingController();

  /// Number of turns for the dice
  RxInt rollCounter = 0.obs;

  /// Is loading
  RxBool isLoading = true.obs;

  /// Is create round loading
  RxBool createRoundLoading = false.obs;

  /// User profile
  Rx<MdProfile> profile = MdProfile().obs;

  /// All bets fetched from API (original copy)
  final RxList<MdBet> _allBets = <MdBet>[].obs;

  /// Remaining bets pool
  final RxList<MdBet> _betsPool = <MdBet>[].obs;

  /// Question for the bet (currently shown)
  RxString bet = ''.obs;

  /// Round details
  RxBool isPurchasing = false.obs;

  /// Is user loading
  RxBool isUserLoading = false.obs;

  /// Can create bet
  Rx<MdCanCreateBet> canCreateBetData = MdCanCreateBet(
    allowed: true,
  ).obs;

  ///  Can show profile (if user has no rounds)
  RxBool get canShowProfile {
    final bool hasPlayedRound = (profile().round?.totalRound ?? 0) >= 1;

    final bool hasUserName = profile().user?.username != null &&
        (profile().user?.username?.isNotEmpty ?? false);

    final bool hasProfile = profile().user?.profileUrl != null &&
        (profile().user?.profileUrl?.isNotEmpty ?? false);

    return (hasPlayedRound || hasUserName || hasProfile).obs;
  }

  /// Init notification click handlers
  Future<void> _initNotificationClick() async {
    await NotificationService().init(
      onPush: onPush,
      onLocal: onLocal,
    );
  }

  /// Show next bet when rolling dice
  void rollDice() {
    if (createRoundLoading()) {
      appSnackbar(
        message: 'Please wait, creating round...',
        snackbarState: SnackbarState.warning,
      );
      return;
    }

    if (_betsPool.isEmpty && _allBets.isNotEmpty) {
      _betsPool.assignAll(_allBets);
    }

    showNextBet();
  }

  /// Get bets from API
  Future<void> getBets() async {
    isLoading(true);
    try {
      final String? savedBetsJson = LocalStore.betsJson();
      final String? betValidTo = LocalStore.betValidTo();

      final DateTime now = DateTime.now();
      final DateTime? validTo =
          betValidTo != null ? DateTime.tryParse(betValidTo)?.toLocal() : null;
      if (savedBetsJson != null && validTo != null && validTo.isAfter(now)) {
        final List<dynamic> decoded = jsonDecode(savedBetsJson);
        final List<MdBet> savedBets =
            decoded.map((e) => MdBet.fromJson(e)).toList();

        _allBets.assignAll(savedBets);
        _betsPool.assignAll(savedBets);

        Future<void>.delayed(
          const Duration(milliseconds: 300),
          () {
            showNextBet();
          },
        );
        return;
      }

      final List<MdBet>? bets = await CreateBetApiRepo.getQuestion();

      if (bets != null && bets.isNotEmpty) {
        _allBets.assignAll(bets);
        _betsPool.assignAll(bets);

        showNextBet();

        final String betsJsonStr =
            jsonEncode(bets.map((MdBet b) => b.toJson()).toList());

        LocalStore.betsJson(betsJsonStr);
        LocalStore.betValidTo(bets.first.validTo?.toIso8601String() ?? '');
      }
    } finally {
      isLoading(false);
    }
  }

  /// Show next bet from the pool
  void showNextBet() {
    if (_betsPool.isEmpty) {
      bet.value = '';
      return;
    }

    rollCounter.value++;

    final int randomIndex = _betsPool.length > 1
        ? (DateTime.now().millisecondsSinceEpoch % _betsPool.length)
        : 0;

    final MdBet nextBet = _betsPool.removeAt(randomIndex);

    bet.value = nextBet.question ?? '';

    enteredBet('');
    messageInputController.clear();
  }

  /// On bet pressed
  Future<void> onBetPressed() async {
    createRoundLoading(true);

    try {
      final MdCanCreateBet? _canCreate = await checkCanCreateRound();

      if (_canCreate != null) {
        if (!(_canCreate.allowed ?? false)) {
          createRoundLoading(false);
          openPurchaseSheet();
          return;
        }
      }

      final String prompt =
          enteredBet().trim().isNotEmpty ? enteredBet() : bet();

      final bool isCustomPrompt = enteredBet().trim().isNotEmpty &&
          messageInputController.text.trim().isNotEmpty;

      final MdRound? _round = await CreateBetApiRepo.createRound(
        prompt: prompt,
        isCustomPrompt: isCustomPrompt,
      );

      if (_round != null) {
        unawaited(
          Get.toNamed(
            Routes.SNAP_SELFIES,
            arguments: MdJoinInvitation(
              id: _round.id ?? '',
              createdAt: _round.createdAt?.toIso8601String(),
              type: _round.id,
              prompt: _round.prompt ?? '',
              isCustomPrompt: _round.isCustomPrompt ?? false,
              isActive: _round.isActive ?? false,
              isDeleted: _round.isDeleted ?? false,
              status: _round.status,
              updatedAt: _round.updatedAt?.toIso8601String(),
              roundJoinedEndAt: _round.roundJoinedEndAt,
              previousRounds: _round.previousRounds,
              participants: <MdParticipant>[
                MdParticipant(
                  createdAt: DateTime.now().toIso8601String(),
                  id: _round.host?.id ?? '',
                  isActive: true,
                  isDeleted: false,
                  isHost: true,
                  joinedAt: DateTime.now().toIso8601String(),
                  userData: _round.host,
                ),
              ],
              host: _round.host,
            ),
          ),
        );
      }
    } finally {
      createRoundLoading(false);
    }
  }

  /// Refresh user profile
  void refreshProfile() {
    getUser();
    canShowProfile.refresh();
  }

  /// User profile
  Future<void> getUser() async {
    isUserLoading(true);
    try {
      final MdProfile? _user = await ProfileApiRepo.getUser();
      if (_user != null) {
        profile(_user);

        roundData(_user.round);
        roundData.refresh();

        final String? userAuthToken = UserProvider.authToken;

        UserProvider.onLogin(
          user: profile().user!,
          userAuthToken: userAuthToken ?? '',
        );

        await _checkForReview(_user);
      }
      isUserLoading(false);
    } on Exception catch (e, st) {
      logE('Error getting user: $e');
      logE(st);
      isUserLoading(false);
    } finally {
      isUserLoading(false);
    }
  }

  /// Check if we should show review dialog
  Future<void> _checkForReview(MdProfile _user) => Future<void>.delayed(
        const Duration(seconds: 1),
        () async {
          final DateTime? installDate =
              DateTime.tryParse(LocalStore.loginTime() ?? '');

          if (installDate == null) {
            return;
          }

          final RatingRepository repo = RatingRepository();
          final RatingService service = RatingService();

          final RatingState state = repo.load();

          final bool shouldAsk = service.shouldShowRating(
            installDate: installDate,
            totalWins: _user.round?.winsCount ?? 0,
            crewStreakDays: 0,
            state: state,
            now: DateTime.now(),
          );

          if (shouldAsk) {
            unawaited(
              Get.toNamed(
                Routes.RATING,
              ),
            );
          }
        },
      );

  /// Check if user can create round
  Future<MdCanCreateBet?> checkCanCreateRound() async {
    try {
      final MdCanCreateBet? _canCreate =
          await CreateBetApiRepo.canCreateRound();

      canCreateBetData(_canCreate);
      canCreateBetData.refresh();

      return _canCreate;
    } on Exception {
      return null;
    }
  }

  /// Handle subscription purchase
  Future<void> handleSubscription({
    required SubscriptionPlanEnum type,
    required String successMessage,
  }) async {
    Get.back();
    isPurchasing(true);

    MdPurchaseResult? result;

    try {
      switch (type) {
        case SubscriptionPlanEnum.weekly:
          result =
              await RevenueCatService.instance.purchaseWeeklySubscription();
          break;
        case SubscriptionPlanEnum.oneTime:
          result = await RevenueCatService.instance.purchaseOneMoreSlay();
          break;
      }

      if (result.status == PurchaseStatus.success) {
        appSnackbar(
          message: successMessage,
          snackbarState: SnackbarState.success,
        );

        await onBetPressed();
        isPurchasing(false);
      } else {
        appSnackbar(
          message:
              'Purchase failed or was cancelled. Status: ${result.status.name}',
          snackbarState: SnackbarState.danger,
        );
        isPurchasing(false);
      }
    } on Exception catch (e) {
      isPurchasing(false);
      appSnackbar(
        message: 'Error occurred: $e',
        snackbarState: SnackbarState.danger,
      );
    } finally {
      isPurchasing(false);
    }
  }

  /// Open purchase sheet
  void openPurchaseSheet() {
    SlayingSheet.openSlayingSheet(
      onSlayed: () {
        handleSubscription(
          type: SubscriptionPlanEnum.oneTime,
          successMessage: 'You have successfully purchased one more slay!'
              '',
        );
      },
      onUnlimitedSlayed: () {
        handleSubscription(
          type: SubscriptionPlanEnum.weekly,
          successMessage:
              'You have successfully subscribed to the weekly unlimited plan!',
        );
      },
    );
  }
}
