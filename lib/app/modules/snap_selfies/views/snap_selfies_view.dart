import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/snap_selfies/widgets/animated_switcher.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/app_button.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/snap_selfies_controller.dart';
import '../models/md_user_selfie.dart';
import '../widgets/selfie_avatar.dart';

/// Snap selfies view
class SnapSelfiesView extends GetView<SnapSelfiesController> {
  /// Snap selfies view constructor
  const SnapSelfiesView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                      Text(
                        '${controller.secondsLeft().toString()}s',
                        style: AppTextStyle.openRunde(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.kF6FCFE,
                        ),
                      ).paddingSymmetric(horizontal: 24),
                      16.verticalSpace
                    ],
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
                  replacement: const SizedBox(
                    width: double.infinity,
                  ),
                  visible: controller.isCurrentUserSelfieTaken() &&
                      !controller.isTimesUp(),
                  child: Padding(
                    padding: REdgeInsets.only(bottom: 32),
                    child: AnimatedTextSwitcher(
                      currentIndex: controller.currentIndex(),
                      texts: controller.texts,
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
                  replacement: const SizedBox(
                    width: double.infinity,
                  ),
                  visible: !controller.isCurrentUserSelfieTaken(),
                  child: AppButton(
                    buttonText: 'Snap Selfie',
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
                  visible: controller.isTimesUp(),
                  child: AppButton(
                    buttonText: 'Let’s Go',
                    onPressed: controller.onLetGo,
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
                    actions: <Widget>[
                      SvgPicture.asset(
                        width: 24.w,
                        height: 24.h,
                        AppImages.shareIcon,
                      )
                    ],
                  ).paddingSymmetric(horizontal: 24),
                  64.verticalSpace,
                  Image(
                    height: 147.h,
                    width: 150.w,
                    image: const AssetImage(
                      AppImages.appLogo,
                    ),
                  ),
                  24.verticalSpace,
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 120.h),
                    child: Obx(
                      () => AutoSizeText(
                        controller.bet(),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.openRunde(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.kffffff,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 20,
                      ),
                    ).paddingSymmetric(horizontal: 24),
                  ),
                  48.verticalSpace,
                  Align(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ...controller.selfies().map(
                                  (MdUserSelfie user) => SelfieAvatar(
                                    user: user,
                                  ).paddingOnly(right: 32),
                                ),
                          ],
                        ),
                      ),
                    ).paddingOnly(left: 24),
                  ),
                  16.verticalSpace,
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    alignment: Alignment.bottomCenter,
                    curve: Curves.easeInOut,
                    child: Obx(
                      () => Visibility(
                        visible: controller.secondsLeft() > 0,
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
      );
}
