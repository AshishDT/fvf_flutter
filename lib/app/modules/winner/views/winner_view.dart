import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/enums/purchase_status.dart';
import 'package:fvf_flutter/app/data/models/md_purchase_result.dart';
import 'package:fvf_flutter/app/data/remote/revenue_cat/revenue_cat_service.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
import 'package:fvf_flutter/app/modules/profile/enums/subscription_enum.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/app_circular_progress.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../utils/app_text_style.dart';
import '../../create_bet/controllers/create_bet_controller.dart';
import '../controllers/winner_controller.dart';
import '../widgets/result_card.dart';

/// Winner View
class WinnerView extends GetView<WinnerController> {
  /// WinnerView Constructor
  const WinnerView({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.kF5FCFF,
          extendBody: true,
          bottomNavigationBar: Obx(
            () => !controller.isLoading() &&
                    !controller.isExposed() &&
                    !controller.showIntroAnimation()
                ? _exposeButton()
                : const SizedBox.shrink(),
          ),
          body: GradientCard(
            child: Stack(
              children: <Widget>[
                Obx(
                  () => AnimatedOpacity(
                    opacity: controller.showIntroAnimation() ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: _mainContent(),
                  ),
                ),
                Obx(
                  () => controller.showIntroAnimation()
                      ? Center(
                          child: Lottie.asset(
                            AppImages.revealStar,
                            repeat: false,
                            onLoaded: (LottieComposition composition) {
                              Future<void>.delayed(
                                composition.duration,
                                () {
                                  controller.onIntroAnimationComplete();
                                },
                              );
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ).withGPad(context),
      );

  Stack _mainContent() => Stack(
        children: <Widget>[
          Obx(
            () => controller.results().isNotEmpty
                ? AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: CachedNetworkImage(
                      imageUrl: _currentRankImageUrl(),
                      width: 1.sw,
                      height: 1.sh,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: AppCircularProgress(),
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.kffffff,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () {
              if (controller.results().isEmpty ||
                  controller.pageController == null) {
                return const SizedBox.shrink();
              }
              return SizedBox(
                height: 1.sh,
                child: Stack(
                  children: <Widget>[
                    PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.results().length,
                      onPageChanged: (int i) {
                        controller.currentRank(i);
                        if (!controller.isExposed()) {
                          Future<void>.delayed(
                            const Duration(seconds: 1),
                            () {
                              controller.wiggleQuestionMark(true);
                              controller.wiggleQuestionMark.refresh();
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final MdResult result = controller.results()[index];

                        return Obx(
                          () => ResultCard(
                            isExposed: controller.isExposed(),
                            triggerQuestionMark:
                                controller.wiggleQuestionMark(),
                            userId: result.userId ?? '',
                            rank: result.rank ?? 0,
                            reason: result.reason ?? '',
                            isCurrentRankIs1:
                                controller.isExposed() || result.rank == 1,
                            ordinalSuffix: getOrdinalSuffix(result.rank ?? 0),
                            selfieUrl: result.selfieUrl,
                            userName: result.userName,
                            reactions: result.reactions,
                            onReactionSelected: (String emoji) {
                              controller.addReaction(
                                emoji: emoji,
                                participantId: result.userId ?? '',
                              );
                              HapticFeedback.mediumImpact();
                            },
                          ).paddingOnly(
                            right: 24.w,
                            left: 24.w,
                            bottom: controller.isExposed() ? 36.h : 100.h,
                          ),
                        );
                      },
                    ),
                    Obx(
                      () => controller.currentRank() != 0
                          ? _backwardButton()
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => controller.currentRank() <
                              controller.results().length - 1
                          ? forwardButton()
                          : const SizedBox.shrink(),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: <Widget>[
                          32.verticalSpace,
                          _appBar(),
                          8.verticalSpace,
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 120.h),
                              child: Obx(
                                () => AutoSizeText(
                                  controller.prompt(),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 40,
                                  style: AppTextStyle.openRunde(
                                    fontSize: 32.sp,
                                    color: AppColors.kffffff,
                                    fontWeight: FontWeight.w700,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                        color: AppColors.k000000
                                            .withValues(alpha: .75),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ).paddingSymmetric(horizontal: 24.w),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );

  /// App bar
  Widget _appBar() => CommonAppBar(
        leadingIcon: AppImages.closeIconWhite,
        onTapOfLeading: () {
          Get.find<CreateBetController>().refreshProfile();
          Get.until(
            (Route<dynamic> route) => route.settings.name == Routes.CREATE_BET,
          );
        },
        actions: <Widget>[
          SvgPicture.asset(
            height: 24.h,
            width: 24.w,
            AppImages.moreVertical,
          ),
        ],
      ).paddingOnly(left: 24.w, right: 21.w);

  /// Forward button
  Positioned forwardButton() => Positioned(
        right: 6.w,
        top: 0,
        bottom: 0,
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: controller.nextPage,
            icon: Image.asset(
              AppImages.nextIosIcon,
              height: 36.h,
              width: 36.w,
            ),
          ),
        ),
      );

  /// Backward button
  Positioned _backwardButton() => Positioned(
        left: 6.w,
        top: 0,
        bottom: 0,
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: controller.prevPage,
            icon: Image.asset(
              AppImages.backIosIcon,
              height: 36.h,
              width: 36.w,
            ),
          ),
        ),
      );

  /// Expose button
  Widget _exposeButton() => Obx(
        () => AppButton(
          buttonText: '',
          height: 57.h,
          onPressed: () {
            ExposeSheet.openExposeSheet(
              onExposed: () => _handleSubscription(
                type: SubscriptionPlanEnum.weekly,
                successMessage:
                    'You have successfully subscribed to the weekly unlimited plan!',
              ),
              onRoundExpose: () => _handleSubscription(
                type: SubscriptionPlanEnum.oneTime,
                successMessage: 'You have successfully exposed this round!',
              ),
            );
          },
          isLoading: controller.isPurchasing(),
          loader: SizedBox(
            width: 35.w,
            height: 35.h,
            child: SleekCircularSlider(
              appearance: CircularSliderAppearance(
                spinnerMode: true,
                size: 50,
                customColors: CustomSliderColors(
                  dotColor: Colors.transparent,
                  trackColor: Colors.transparent,
                  progressBarColor: Colors.transparent,
                  shadowColor: Colors.black38,
                  progressBarColors: <Color>[
                    const Color(0xFFFFDBF6),
                    const Color(0xFFFF70DB),
                    const Color(0xFF6C75FF),
                    const Color(0xFF4DD0FF),
                  ],
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppImages.buttonBg),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(28).r,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Expose Everyone 👀',
                style: AppTextStyle.openRunde(
                  fontSize: 18.sp,
                  color: AppColors.kFAFBFB,
                  fontWeight: FontWeight.w700,
                  height: .8,
                ),
              ),
              4.verticalSpace,
              Text(
                'See how everyone placed!',
                style: AppTextStyle.openRunde(
                  fontSize: 12.sp,
                  color: AppColors.kFAFBFB,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ).paddingAll(24.w);

  /// _currentRankImageUrl
  String _currentRankImageUrl() =>
      controller.results()[controller.currentRank()].selfieUrl ?? '';

  /// getOrdinalSuffix
  String getOrdinalSuffix(int number) {
    if (number <= 0) {
      return '';
    }

    final int mod100 = number % 100;

    if (mod100 >= 11 && mod100 <= 13) {
      return 'th';
    }

    switch (number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// _handleSimpleSubscription
  Future<void> _handleSubscription({
    required SubscriptionPlanEnum type,
    required String successMessage,
  }) async {
    Get.back();
    controller.isPurchasing(true);

    final String roundId = controller.roundDetails().round?.id ?? '';
    MdPurchaseResult? result;

    try {
      switch (type) {
        case SubscriptionPlanEnum.weekly:
          result = await RevenueCatService.instance.purchaseWeeklySubscription(
            roundId: roundId,
          );
          break;
        case SubscriptionPlanEnum.oneTime:
          result = await RevenueCatService.instance.purchaseCurrentRound(
            roundId: roundId,
          );
          break;
      }

      if (result.status == PurchaseStatus.success) {
        controller
          ..isExposed(true)
          ..isExposed.refresh();

        appSnackbar(
          message: successMessage,
          snackbarState: SnackbarState.success,
        );
        controller.isPurchasing(false);

        controller.updateScreenshotPermission();
      } else {
        appSnackbar(
          message:
              'Purchase failed or was cancelled. Status: ${result.status.name}',
          snackbarState: SnackbarState.danger,
        );
        controller.isPurchasing(false);
      }
    } on Exception catch (e) {
      controller.isPurchasing(false);
      appSnackbar(
        message: 'Error occurred: $e',
        snackbarState: SnackbarState.danger,
      );
    } finally {
      controller.isPurchasing(false);
    }
  }
}
