import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../../snap_selfies/widgets/selfie_avatar.dart';
import '../controllers/ai_choosing_controller.dart';
import '../widgets/ai_choosing_avatar.dart';

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
                  leadingIcon: AppImages.closeIconWhite,
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
                ).paddingSymmetric(horizontal: 24),
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
                ).paddingSymmetric(horizontal: 24),
                24.verticalSpace,
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 120.w,
                    ),
                    child: Obx(
                      () => AutoSizeText(
                        controller.bet(),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 20,
                        style: AppTextStyle.openRunde(
                          fontSize: 24.sp,
                          color: AppColors.kFAFBFB,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 24),
                61.verticalSpace,
                SizedBox(
                  height: 200.h,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemBuilder: (BuildContext context, int index) {
                      if (controller.participants().isEmpty) {
                        return const SizedBox();
                      }

                      final int realIndex =
                          index % controller.participants().length;
                      final MdParticipant participant =
                          controller.participants()[realIndex];

                      return AnimatedBuilder(
                        animation: controller.pageController,
                        builder: (BuildContext context, Widget? child) {
                          double value = 1;
                          if (controller
                              .pageController.position.haveDimensions) {
                            value =
                                (controller.pageController.page! - index).abs();
                            value = (1 - (value * 0.3)).clamp(0.0, 1.0);
                          }

                          final bool isCenter =
                              controller.pageController.page?.round() == index;

                          return AnimatedOpacity(
                            opacity: isCenter ? 1 : 0.32,
                            duration: 300.milliseconds,
                            child: Center(
                              child: Transform.scale(
                                scale: Curves.easeOut.transform(value),
                                child: AiChoosingAvatar(
                                  participant: participant,
                                  showBorders: isCenter,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                68.verticalSpace,
                Align(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ...controller.participants().map(
                                (MdParticipant participant) => SelfieAvatar(
                                  participant: participant,
                                ).paddingOnly(right: 32),
                              ),
                        ],
                      ),
                    ),
                  ).paddingOnly(left: 24),
                ),
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
