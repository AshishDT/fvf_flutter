import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';
import '../../snap_selfies/widgets/selfie_avatar.dart';
import '../controllers/ai_choosing_controller.dart';

/// AiChoosingView
class AiChoosingView extends GetView<AiChoosingController> {
  /// AiChoosingView Constructor
  const AiChoosingView({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: AppColors.kF5FCFF,
          body: Stack(
            children: <Widget>[
              GradientCard(
                height: 1.sh,
                width: 1.sw,
                child: const SizedBox.shrink(),
              ),
              SizedBox(
                height: 1.sh,
                width: 1.sw,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (int index) {
                    controller.currentIndex(index);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (controller.participants().isEmpty) {
                      return const SizedBox();
                    }

                    final int realIndex =
                        index % controller.participants().length;
                    final MdParticipant participant =
                        controller.participants()[realIndex];

                    return Obx(
                      () => AnimatedOpacity(
                        duration: 300.milliseconds,
                        opacity: controller.isAiFailed() ? 0 : 0.36,
                        child: CachedNetworkImage(
                          imageUrl: participant.selfieUrl!,
                          width: 1.sw,
                          height: 1.sh,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          errorWidget: (_, __, ___) => const Center(
                            child: Icon(
                              Icons.error,
                              color: AppColors.kffffff,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: AnimatedListView(
                  children: <Widget>[
                    CommonAppBar(
                      leadingIcon: AppImages.closeIconWhite,
                      onTapOfLeading: () {
                        if (controller.isViewOnly()) {
                          Get.offAllNamed(
                            Routes.CREATE_BET,
                          );
                          return;
                        }
                        DialogHelper.onBackOfAiChoosing(
                          onPositiveClick: () {
                            Get.offAllNamed(
                              Routes.CREATE_BET,
                            );
                          },
                        );
                      },
                      actions: <Widget>[
                        GestureDetector(
                          onTap: () {
                            controller.shareViewOnlyLink();
                          },
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
                    AnimatedSize(
                      duration: 300.milliseconds,
                      curve: Curves.easeInOut,
                      reverseDuration: 300.milliseconds,
                      child: Obx(
                        () => Visibility(
                          replacement: SizedBox(
                            width: context.width,
                          ),
                          visible: controller.isAiFailed(),
                          child: 64.verticalSpace,
                        ),
                      ),
                    ),
                    Center(
                      child: AnimatedSize(
                        duration: 300.milliseconds,
                        curve: Curves.easeInOut,
                        reverseDuration: 300.milliseconds,
                        child: Obx(
                          () => Visibility(
                            visible: controller.isAiFailed(),
                            replacement: SizedBox(
                              width: context.width,
                            ),
                            child: Text(
                              'AI fell asleep 😴',
                              style: AppTextStyle.openRunde(
                                fontSize: 40.sp,
                                color: AppColors.kffffff,
                                fontWeight: FontWeight.w700,
                                height: 1,
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
                              fontSize: controller.isAiFailed() ? 24.sp : 40.sp,
                              color: controller.isAiFailed()
                                  ? AppColors.kFAFBFB
                                  : AppColors.kffffff,
                              fontWeight: controller.isAiFailed()
                                  ? FontWeight.w600
                                  : FontWeight.w700,
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
                    ).paddingSymmetric(horizontal: 24),
                  ],
                ),
              ),
              Positioned(
                bottom: 36.h,
                left: 0,
                right: 0,
                child: Align(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ...controller.participants().asMap().entries.map(
                                (MapEntry<int, MdParticipant> entry) {
                                  final int index = entry.key;
                                  final MdParticipant participant = entry.value;
                                  return SelfieAvatar(
                                    participant: participant,
                                    showBorder: !controller.isAiFailed() &&
                                        controller.currentIndex() %
                                                controller
                                                    .participants()
                                                    .length ==
                                            index,
                                  ).paddingOnly(right: 32);
                                },
                              ),
                            ],
                          ),
                        ),
                      ).paddingOnly(left: 32),
                      AnimatedSize(
                        duration: 300.milliseconds,
                        alignment: Alignment.topCenter,
                        curve: Curves.easeInOut,
                        child: Obx(
                          () => Visibility(
                            visible: controller.isAiFailed(),
                            child: 56.verticalSpace,
                          ),
                        ),
                      ),
                      AnimatedSize(
                        duration: 300.milliseconds,
                        alignment: Alignment.topCenter,
                        curve: Curves.easeInOut,
                        child: Obx(
                          () => Visibility(
                            visible: controller.isAiFailed(),
                            child: AppButton(
                              isLoading: controller.isWakingUp(),
                              buttonText: 'Wake it up',
                              onPressed: () {
                                controller.wakeItUp();
                              },
                            ),
                          ),
                        ),
                      ).paddingSymmetric(horizontal: 24),
                    ],
                  ),
                ),
              ),
              Obx(
                () => !controller.isAiFailed()
                    ? Positioned(
                        bottom: -10.h,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Opacity(
                            opacity: .56,
                            child: Transform.scale(
                              scale: .24,
                              child: Image.asset(
                                AppImages.shineLoader,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ).withGPad(context, color: Colors.black),
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
