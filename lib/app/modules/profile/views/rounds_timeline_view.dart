import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/participant_wrapper.dart';
import 'package:get/get.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../winner/widgets/result_card.dart';
import '../controllers/profile_controller.dart';
import '../enums/subscription_enum.dart';
import '../models/md_user_rounds.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// Rounds time lines view
class RoundsTimeLinesView extends StatelessWidget {
  /// Constructor
  const RoundsTimeLinesView({
    required this.controller,
    super.key,
  });

  /// Controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Obx(
        () => ParticipantWrapper(
          isLoading: controller.isRoundsLoading(),
          child: controller.rounds().isNotEmpty
              ? PageView.builder(
                  controller: controller.roundPageController,
                  itemCount: controller.rounds().length,
                  scrollDirection: Axis.vertical,
                  onPageChanged: _onChangeTopPageView,
                  itemBuilder: (BuildContext context, int index) => Obx(
                    () {
                      final MdRound round = controller.rounds[index];

                      controller.ensureRoundControllers(
                        index,
                        round.results?.length ?? 0,
                      );

                      final PageController inner =
                          controller.roundInnerPageController[index]!;
                      final int itemCount = round.results?.length ?? 0;
                      final int currentInner =
                          controller.roundCurrentResultIndex[index]!();

                      if (itemCount == 0) {
                        return const SizedBox.shrink();
                      }

                      final MdResult currentResult =
                          round.results![currentInner];

                      return GradientCard(
                        child: Stack(
                          children: <Widget>[
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: CachedNetworkImage(
                                imageUrl: currentResult.selfieUrl ?? '',
                                width: 1.sw,
                                height: 1.sh,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => const Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                                errorWidget: (_, __, ___) => const Center(
                                  child: Icon(Icons.error,
                                      color: AppColors.kffffff),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.sh,
                              child: Stack(
                                children: <Widget>[
                                  PageView.builder(
                                    controller: inner,
                                    itemCount: itemCount,
                                    onPageChanged: (int i) {
                                      _onChangeOfInnerPageView(index, i);
                                    },
                                    itemBuilder: (BuildContext context, int i) {
                                      final MdResult result = round.results![i];
                                      final RxBool trigger =
                                          controller.roundWiggleMark[index]!;
                                      final RxBool isExposedRx =
                                          controller.roundExposed[index]!;

                                      return Obx(
                                        () => ResultCard(
                                          isExposed: isExposedRx(),
                                          triggerQuestionMark: trigger(),
                                          userId: result.userId ?? '',
                                          supabaseId: result.supabaseId ?? '',
                                          rank: result.rank ?? 0,
                                          reason: result.reason ?? '',
                                          isCurrentRankIs1:
                                              isExposedRx() || result.rank == 1,
                                          ordinalSuffix: getOrdinalSuffix(
                                              result.rank ?? 0),
                                          selfieUrl: result.selfieUrl,
                                          userName: result.userName,
                                          reactions: result.reactions,
                                          onReactionSelected: (String emoji) {
                                            controller.addRoundReaction(
                                              roundId: round.roundId ?? '',
                                              emoji: emoji,
                                              participantId:
                                                  result.userId ?? '',
                                            );
                                            HapticFeedback.mediumImpact();
                                          },
                                        ).paddingOnly(
                                          right: 24.w,
                                          left: 24.w,
                                          bottom:
                                              (isExposedRx()) ? 36.h : 100.h,
                                        ),
                                      );
                                    },
                                  ),
                                  _backArrowButton(index),
                                  _nextArrowButton(index, itemCount),
                                  _appBar(),
                                  _promptCard(round),
                                ],
                              ),
                            ),
                            _exposeButton(index, round),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      );

  /// Expose button at the bottom
  Positioned _exposeButton(int index, MdRound round) => Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: Obx(
          () {
            final RxBool exposed = controller.roundExposed[index] ?? false.obs;
            return (!exposed())
                ? _roundExposeButton(index, round)
                : const SizedBox.shrink();
          },
        ),
      );

  /// Prompt card at the top
  Positioned _promptCard(MdRound round) => Positioned(
        top: 100,
        left: 24,
        right: 24,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 120.h),
            child: AutoSizeText(
              controller.roundPrompt(round) ?? '',
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
                    color: AppColors.k000000.withValues(alpha: .75),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// App bar at the top
  Positioned _appBar() => Positioned(
        top: 30,
        left: 24,
        right: 24,
        child: CommonAppBar(
          leadingIconColor: AppColors.kFAFBFB,
          onTapOfLeading: () {
            if (controller.currentIndex() == 1) {
              controller.pageController.animateToPage(
                0,
                duration: 500.milliseconds,
                curve: Curves.easeInOut,
              );
            } else {
              Get.back();
            }
          },
          actions: <Widget>[
            GestureDetector(
              onTap: () {},
              child: SvgPicture.asset(
                AppImages.moreVertical,
                width: 24.w,
                height: 24.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.kFAFBFB,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      );

  /// Next arrow button
  Obx _nextArrowButton(int index, int itemCount) => Obx(
        () => (controller.roundCurrentResultIndex[index]!() < itemCount - 1)
            ? Positioned(
                right: 6.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => controller.roundNextPage(index),
                    icon: Image.asset(
                      AppImages.nextIosIcon,
                      height: 36.h,
                      width: 36.w,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      );

  /// Back arrow button
  Obx _backArrowButton(int index) => Obx(
        () => (controller.roundCurrentResultIndex[index]!() > 0)
            ? Positioned(
                left: 6.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => controller.roundPrevPage(index),
                    icon: Image.asset(
                      AppImages.backIosIcon,
                      height: 36.h,
                      width: 36.w,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      );

  /// On change of inner page view
  void _onChangeOfInnerPageView(int index, int i) {
    controller.roundCurrentResultIndex[index]!(i);
    if (!(controller.roundExposed[index]?.call() ?? false)) {
      Future<void>.delayed(
        const Duration(seconds: 1),
        () {
          controller.roundWiggleMark[index]!(true);
          controller.roundWiggleMark[index]!.refresh();
        },
      );
    }
    controller.updateRoundScreenshotPermission(index);
  }

  /// On change of top page view
  void _onChangeTopPageView(int i) {
    controller.currentRound(i);
    if (controller.rounds[i].rank == null) {
      controller.animatedIndex(i);
    }

    final RxInt? rx = controller.roundCurrentResultIndex[i];
    if (rx != null) {
      rx(0);
      rx.refresh();
    }

    controller.updateRoundScreenshotPermission(i);
    controller.roundWiggleMark[i]?.call(false);
    controller.roundWiggleMark[i]?.refresh();
  }

  /// Keep same ordinal helper used in WinnerView
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

  /// Round-level expose button using controller hooks
  Widget _roundExposeButton(int index, MdRound round) => AppButton(
        buttonText: '',
        height: 57.h,
        onPressed: () {
          ExposeSheet.openExposeSheet(
            onExposed: () => controller.handleRoundSubscription(
              index: index,
              type: SubscriptionPlanEnum.weekly,
              roundId: round.roundId ?? '',
              successMessage:
                  'You have successfully subscribed to the weekly unlimited plan!',
            ),
            onRoundExpose: () => controller.handleRoundSubscription(
              index: index,
              type: SubscriptionPlanEnum.oneTime,
              roundId: round.roundId ?? '',
              successMessage: 'You have successfully exposed this round!',
            ),
          );
        },
        isLoading: controller.roundPurchasing[index]?.call() ?? false,
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
      ).paddingAll(24.w);
}
