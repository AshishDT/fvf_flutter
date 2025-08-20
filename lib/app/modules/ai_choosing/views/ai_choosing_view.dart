import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';

import '../controllers/ai_choosing_controller.dart';

/// AiChoosingView
class AiChoosingView extends GetView<AiChoosingController> {
  /// AiChoosingView Constructor
  const AiChoosingView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        body: GradientCard(
          child: SafeArea(
            child: AnimatedListView(
              children: <Widget>[
                CommonAppBar(
                  leadingIcon: AppImages.closeIcon,
                  actions: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppImages.shareIcon,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          AppColors.kffffff,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 24.w),
                64.verticalSpace,
                Center(
                  child: Text(
                    'AI Choosing...',
                    style: AppTextStyle.openRunde(
                      fontSize: 40.sp,
                      color: AppColors.kffffff,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 24.w),
                24.verticalSpace,
                Center(
                  child: AutoSizeText(
                    'Most Likely to Start an OF?',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 20,
                    style: AppTextStyle.openRunde(
                      fontSize: 24.sp,
                      color: AppColors.kFAFBFB,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).paddingSymmetric(horizontal: 24.w),
                61.verticalSpace,
                SizedBox(
                  height: 200.h,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.images.length,
                    itemBuilder: (BuildContext context, int index) =>
                        AnimatedBuilder(
                      animation: controller.pageController,
                      builder: (BuildContext context, Widget? child) {
                        double value = 1;
                        if (controller.pageController.position.haveDimensions) {
                          value =
                              (controller.pageController.page! - index).abs();
                          value = (1 - (value * 0.3)).clamp(0.0, 1.0);
                        }
                        final bool isCenter =
                            controller.pageController.page?.round() == index;
                        return AnimatedOpacity(
                          opacity: isCenter ? 1 : 0.7,
                          duration: 300.milliseconds,
                          child: Center(
                            child: Transform.scale(
                              scale: Curves.easeOut.transform(value),
                              child: GradientCard(
                                height: 200.w,
                                width: 200.w,
                                bgImage: AppImages.profileImgBg,
                                padding: REdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.kFAFBFB,
                                    border: Border.all(
                                      color: AppColors.kFAFBFB,
                                      width: 4.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                68.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    personCard(name: 'You'),
                    personCard(name: 'Tom'),
                    personCard(name: 'Alice'),
                    personCard(name: 'Mary'),
                  ],
                ).paddingSymmetric(horizontal: 24.w),
              ],
            ),
          ),
        ),
      );

  /// Person Card
  Column personCard({required String name}) => Column(
        children: <Widget>[
          Container(
            height: 56.w,
            width: 56.w,
            padding: REdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.kFB46CD,
                  AppColors.k6C75FF,
                  AppColors.k0DBFFF,
                ],
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kFAFBFB,
              ),
            ),
          ),
          4.verticalSpace,
          Text(
            name,
            style: AppTextStyle.openRunde(
              fontSize: 16.sp,
              color: AppColors.kffffff,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
}
