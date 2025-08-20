import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
            AppButton(
              buttonText: 'Snap Selfie',
              onPressed: () {},
            ).paddingSymmetric(horizontal: 24),
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
                    height: 132.h,
                    width: 136.w,
                    image: const AssetImage(
                      AppImages.appLogo,
                    ),
                  ),
                  24.verticalSpace,
                  Text(
                    'Most Likely to Start an OF?',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.openRunde(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kffffff,
                    ),
                  ).paddingSymmetric(horizontal: 24),
                  48.verticalSpace,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        ...controller.selfies.map(
                          (MdUserSelfie user) => SelfieAvatar(
                            user: user,
                            avatarColors: controller.avatarColors,
                          ).paddingOnly(right: 32),
                        ),
                      ],
                    ),
                  ).paddingOnly(left: 24),
                ],
              ),
            ),
          ),
        ),
      );
}
