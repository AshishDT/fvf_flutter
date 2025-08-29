import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/animated_switcher.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/custom_type_writer.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/dialog_helper.dart';
import '../controllers/snap_selfies_controller.dart';
import '../widgets/selfie_avatar_icon.dart';
import '../widgets/user_self_participant_card.dart';

/// Snap selfies view
class SnapSelfiesView extends GetView<SnapSelfiesController> {
  /// Snap selfies view constructor
  const SnapSelfiesView({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.kF5FCFF,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                curve: Curves.easeInOut,
                child: Obx(
                  () => Visibility(
                    visible: controller.secondsLeft() > 0,
                    replacement: const SizedBox(
                      width: double.infinity,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              AppImages.timerIcon,
                              height: 24.h,
                              width: 24.w,
                            ),
                            Obx(
                              () => AnimatedDigitWidget(
                                duration: const Duration(milliseconds: 600),
                                separateLength: 1,
                                loop: false,
                                value: controller.secondsLeft(),
                                suffix: 's',
                                textStyle: AppTextStyle.openRunde(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kF6FCFE,
                                ),
                              ),
                            ),
                          ],
                        ),
                        16.verticalSpace
                      ],
                    ).paddingSymmetric(horizontal: 24),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                curve: Curves.easeInOut,
                child: Obx(
                  () => Visibility(
                    replacement: const SizedBox(
                      width: double.infinity,
                    ),
                    visible: controller.isCurrentUserSelfieTaken() &&
                        !controller.isTimesUp(),
                    child: Padding(
                      padding: REdgeInsets.only(bottom: 32),
                      child: AnimatedTextSwitcher(
                        currentIndex: controller.currentIndex(),
                        texts: controller.preSelfieStrings(),
                      ).paddingSymmetric(horizontal: 24),
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                curve: Curves.easeInOut,
                child: Obx(
                  () => Visibility(
                    visible: controller.isHost() &&
                        !controller.isInvitationSend() &&
                        !controller.isTimesUp() && !controller.isStartingRound(),
                    child: AppButton(
                      buttonText: 'Add Friends',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            width: 18.w,
                            height: 18.h,
                            AppImages.shareIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.kffffff,
                              BlendMode.srcIn,
                            ),
                          ),
                          8.horizontalSpace,
                          Text(
                            'Add Friends',
                            style: AppTextStyle.openRunde(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.kffffff,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        controller.shareUri();
                      },
                    ).paddingSymmetric(horizontal: 24),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                curve: Curves.easeInOut,
                child: Obx(
                  () => Visibility(
                    replacement: const SizedBox(
                      width: double.infinity,
                    ),
                    visible: controller.isHost()
                        ? controller.isInvitationSend() &&
                            (!controller.isCurrentUserSelfieTaken() &&
                                controller.secondsLeft() > 0)
                        : (!controller.isCurrentUserSelfieTaken() &&
                            controller.secondsLeft() > 0),
                    child: AppButton(
                      buttonText: 'Snap Pic',
                      isLoading: controller.submittingSelfie(),
                      onPressed: controller.onSnapSelfie,
                    ).paddingSymmetric(horizontal: 24),
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.bottomCenter,
                curve: Curves.easeInOut,
                child: Obx(
                  () => Visibility(
                    replacement: const SizedBox(
                      width: double.infinity,
                    ),
                    visible:
                        controller.isTimesUp() && controller.isProcessing() ||
                            controller.isStartingRound(),
                    child: AppButton(
                      buttonText: controller.isProcessing() ||
                              controller.isStartingRound()
                          ? 'Processing...'
                          : 'Let’s Go',
                      onPressed: () {
                        if (controller.isProcessing() ||
                            controller.isStartingRound()) {
                          appSnackbar(
                            message:
                                'Please wait, your selfies are being processed.',
                            snackbarState: SnackbarState.warning,
                          );
                          return;
                        } else {
                          controller.onLetGo();
                        }
                      },
                    ).paddingSymmetric(horizontal: 24),
                  ),
                ),
              ),
            ],
          ),
          body: GradientCard(
            child: Align(
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: AnimatedListView(
                  children: <Widget>[
                    CommonAppBar(
                      onTapOfLeading: () {
                        DialogHelper.onBackOfAiChoosing(
                          onPositiveClick: () {
                            Get.offAllNamed(
                              Routes.CREATE_BET,
                            );
                          },
                        );
                      },
                      actions: <Widget>[
                        SvgPicture.asset(
                          width: 24.w,
                          height: 24.h,
                          AppImages.shareIcon,
                        )
                      ],
                    ).paddingSymmetric(horizontal: 24),
                    64.verticalSpace,
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 120.h),
                      child: Obx(
                        () => CustomTypewriterText(
                          text: controller.joinedInvitationData().prompt ?? '',
                        ),
                      ).paddingSymmetric(horizontal: 24),
                    ),
                    48.verticalSpace,
                    Obx(
                      () => CurrentUserSelfieAvatar(
                        participant: controller.selfParticipant(),
                        userName: globalUser().username,
                      ),
                    ),
                    24.verticalSpace,
                    Align(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ...controller
                                  .participantsWithoutCurrentUser()
                                  .map(
                                    (MdParticipant participant) =>
                                        SelfieAvatarIcon(
                                      participant: participant,
                                    ).paddingOnly(right: 32),
                                  ),
                            ],
                          ),
                        ),
                      ).paddingOnly(left: 32),
                    ),
                    16.verticalSpace,
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      child: Obx(
                        () => Visibility(
                          visible: controller.secondsLeft() > 0 &&
                              controller.isHost() &&
                              controller.isInvitationSend(),
                          child: TextButton(
                            onPressed: () {
                              controller.shareUri();
                            },
                            child: Text(
                              'Resend Invites',
                              style: AppTextStyle.openRunde(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.kF1F2F2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
