import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/dialog_helper.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../utils/app_text_style.dart';
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
            () => !controller.isExposed() && !controller.isFromProfile()
                ? _exposeButton()
                : const SizedBox.shrink(),
          ),
          body: GradientCard(
            child: Stack(
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
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
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
                              final MdResult result =
                                  controller.results()[index];

                              return Obx(
                                () => ResultCard(
                                  isExposed: controller.isExposed(),
                                  triggerQuestionMark:
                                      controller.wiggleQuestionMark(),
                                  isFromProfile: controller.isFromProfile(),
                                  rank: result.rank ?? 0,
                                  reason: result.reason ?? '',
                                  isCurrentRankIs1: controller.isExposed() ||
                                      result.rank == 1,
                                  ordinalSuffix:
                                      getOrdinalSuffix(result.rank ?? 0),
                                  reaction: result.reaction,
                                  selfieUrl: result.selfieUrl,
                                  userName: result.userName,
                                  onReactionSelected: (String emoji) {
                                    controller.addReaction(
                                      emoji: emoji,
                                      participantId: result.userId ?? '',
                                    );
                                  },
                                ).paddingOnly(
                                  right: 24.w,
                                  left: 24.w,
                                  bottom: controller.isExposed() ||
                                          controller.isFromProfile()
                                      ? 36.h
                                      : 117.h,
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
                                    constraints:
                                        BoxConstraints(maxHeight: 120.h),
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
                                            const Shadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 4,
                                              color: Color(0x33000000),
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
            ),
          ),
        ).withGPad(context, color: Colors.black),
      );

  /// App bar
  Widget _appBar() => CommonAppBar(
        leadingIcon: AppImages.closeIconWhite,
        onTapOfLeading: () {
          controller.roundId().isNotEmpty
              ? Get.back()
              : DialogHelper.onBackOfWinner(
                  onPositiveClick: () {
                    Get.offAllNamed(
                      Routes.CREATE_BET,
                    );
                  },
                );
        },
        actions: <Widget>[
          Container(
            height: 34.w,
            width: 34.w,
            decoration: BoxDecoration(
              color: AppColors.kFAFBFB.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AppImages.dice,
            ),
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
            icon: SvgPicture.asset(
              AppImages.forwardArrow,
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
            icon: SvgPicture.asset(
              AppImages.backwardArrow,
            ),
          ),
        ),
      );

  /// Expose button
  Widget _exposeButton() => AppButton(
        buttonText: '',
        height: 57.h,
        onPressed: () {
          ExposeSheet.openExposeSheet(onExposed: () {
            Get.back();
            appSnackbar(
              message:
                  'You have successfully subscribed to the unlimited plan!',
              snackbarState: SnackbarState.success,
            );
            controller.isExposed(true);
          }, onRoundExpose: () {
            Get.back();
            appSnackbar(
              message: 'You have successfully exposed this round!',
              snackbarState: SnackbarState.success,
            );
            controller.isExposed(true);
          });
        },
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

  /// _currentRankImageUrl
  String _currentRankImageUrl() =>
      controller.results()[controller.currentRank()].selfieUrl ?? '';

  /// getOrdinalSuffix
  String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
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
}
