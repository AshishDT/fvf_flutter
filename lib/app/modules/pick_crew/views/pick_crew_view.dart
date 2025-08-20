import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../ui/components/animated_list_view.dart';
import '../../../ui/components/common_app_bar.dart';
import '../../../ui/components/gradient_card.dart';
import '../controllers/pick_crew_controller.dart';

/// Pick crew view
class PickCrewView extends GetView<PickCrewController> {
  /// Constructor
  const PickCrewView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AppButton(
          buttonText: 'Pick your crew',
          child:Row(
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
                'Pick your crew',
                style: AppTextStyle.openRunde(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.kffffff,
                ),
              ),
            ],
          ),
          onPressed: () {
            Get.toNamed(Routes.PICK_FRIENDS);
          },
        ).paddingSymmetric(horizontal: 24),
        body: GradientCard(
          child: Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: AnimatedListView(
                padding: REdgeInsets.symmetric(horizontal: 24),
                children: <Widget>[
                  CommonAppBar(
                    actions: <Widget>[
                      SvgPicture.asset(
                        width: 24.w,
                        height: 24.h,
                        AppImages.shareIcon,
                      )
                    ],
                  ),
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
                  ),
                  48.verticalSpace,
                  Align(
                    child: _profileWidget(
                      name: 'You',
                      iconPath: AppImages.youProfile,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _profileWidget({
    required String name,
    required String iconPath,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            height: 56.h,
            width: 56.w,
            image: AssetImage(iconPath),
          ),
          2.verticalSpace,
          Text(
            name,
            style: AppTextStyle.openRunde(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.kffffff,
            ),
          ),
        ],
      );
}
