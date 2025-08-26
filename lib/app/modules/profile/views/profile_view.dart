import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/profile_wrapper.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

/// ProfileView
class ProfileView extends GetView<ProfileController> {
  /// Profile Constructor
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => IgnorePointer(
          ignoring: false ?? controller.isEditing(),
          child: Scaffold(
            backgroundColor: AppColors.kF5FCFF,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Obx(
              () => AnimatedSize(
                duration: 300.milliseconds,
                child: Visibility(
                  visible:
                      !controller.isExposed() && controller.currentIndex() == 1,
                  child: AppButton(
                    buttonText: '',
                    height: 57.h,
                    onPressed: () {},
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
                  ).paddingAll(24.w),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: controller.currentIndex() == 1
                      ? controller
                              .participants()[controller.currentRank()]
                              .selfieUrl ??
                          ''
                      : 'https://images.unsplash.com/photo-1612000529646-f424a2aa1bff?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHNlbGZpZXxlbnwwfHwwfHx8MA%3D%3D',
                  width: 1.sw,
                  height: 1.sh,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (_, __, ___) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      CommonAppBar(
                        leadingIconColor: AppColors.kFAFBFB,
                        actions: <Widget>[
                          GestureDetector(
                            onTap: () {},
                            child: SvgPicture.asset(
                              AppImages.shareIcon,
                              width: 24.w,
                              height: 24.h,
                              colorFilter: const ColorFilter.mode(
                                AppColors.kFAFBFB,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 24.w),
                      Expanded(
                        child: PageView(
                          controller: controller.pageController,
                          scrollDirection: Axis.vertical,
                          physics: controller.currentIndex() == 0
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          onPageChanged: (int value) {
                            controller.currentIndex(value);
                            controller.currentRank(0);
                          },
                          children: <Widget>[
                            Obx(
                              () => ProfileWrapper(
                                isLoading: false ?? controller.isLoading(),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            controller
                                                    .profile()
                                                    ?.user
                                                    ?.username ??
                                                'Anonymous',
                                            style: AppTextStyle.openRunde(
                                              color: AppColors.kffffff,
                                              fontSize: 32.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          if (true ??
                                              controller
                                                  .isCurrentUser) ...<Widget>[
                                            4.horizontalSpace,
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    Routes.EDIT_PROFILE);
                                              },
                                              child: SvgPicture.asset(
                                                AppImages.penIcon,
                                                height: 16.h,
                                                color: AppColors.kFAFBFB,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    8.verticalSpace,
                                    Row(
                                      spacing: 8.w,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _streakChip(
                                          icon: AppImages.trophyIcon,
                                          title:
                                              '${controller.profile()?.user?.totalWins ?? 0} Winner',
                                          bgColor: AppColors.k09DB84
                                              .withValues(alpha: .58),
                                        ),
                                        _streakChip(
                                          icon: AppImages.fireIcon,
                                          title:
                                              '${controller.profile()?.user?.winnerStreakCount ?? 0} Days',
                                          bgColor: AppColors.kFFC300
                                              .withValues(alpha: .87),
                                        ),
                                        _streakChip(
                                          icon: AppImages.emojiIcon,
                                          title: 'Funniest',
                                          bgColor: AppColors.kEE4AD1
                                              .withValues(alpha: .88),
                                        ),
                                      ],
                                    ),
                                    24.verticalSpace,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _profileInfo(
                                          value:
                                              '${controller.profile()?.round?.winsCount ?? 0}',
                                          title: 'Wins',
                                        ),
                                        _profileInfo(
                                          value:
                                              '${controller.profile()?.round?.totalRound ?? 0}',
                                          title: 'Rounds',
                                        ),
                                        _profileInfo(
                                          value: '91',
                                          title: 'Reactions',
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      'This is tom, he is cool. BDE frfr.',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 20.sp,
                                        color: AppColors.kffffff,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    16.verticalSpace,
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(
                                          minWidth: 56.w, minHeight: 56.w),
                                      onPressed: () {
                                        controller.pageController.jumpToPage(1);
                                        controller.currentIndex(1);
                                      },
                                      icon: Transform.rotate(
                                        angle: -math.pi / 2,
                                        child: SvgPicture.asset(
                                          AppImages.backwardArrow,
                                        ),
                                      ),
                                    ),
                                    24.verticalSpace,
                                  ],
                                ),
                              ).paddingSymmetric(horizontal: 24.w),
                            ),
                            Stack(
                              children: <Widget>[
                                PageView.builder(
                                  controller:
                                      controller.participantPageController,
                                  itemCount: controller.participants().length,
                                  onPageChanged: (int i) =>
                                      controller.currentRank(i),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final MdParticipant participant =
                                        controller.participants[index];
                                    return Obx(
                                      () => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Most likely to start a cult?',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle.openRunde(
                                              fontSize: 32.sp,
                                              color: AppColors.kffffff,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: SvgPicture.asset(
                                                    AppImages.smilyIcon,
                                                    height: 32.w,
                                                  ),
                                                ),
                                              ),
                                              16.verticalSpace,
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      500.r),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: participant
                                                                    .selfieUrl ??
                                                                '',
                                                            width: 24.w,
                                                            height: 24.w,
                                                            fit: BoxFit.cover,
                                                            placeholder: (_,
                                                                    __) =>
                                                                const Center(
                                                                    child: CircularProgressIndicator(
                                                                        strokeWidth:
                                                                            2)),
                                                            errorWidget: (_, __,
                                                                    ___) =>
                                                                const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2),
                                                            ),
                                                          ),
                                                        ),
                                                        4.horizontalSpace,
                                                        Flexible(
                                                          child: Text(
                                                            participant.userData
                                                                    ?.username ??
                                                                '',
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: AppTextStyle
                                                                .openRunde(
                                                              fontSize: 24.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: AppColors
                                                                  .kffffff,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {},
                                                    child: SvgPicture.asset(
                                                      AppImages.shareIcon,
                                                      height: 32.w,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ).paddingOnly(
                                          right: 24.w,
                                          left: 24.w,
                                          bottom: controller.isExposed()
                                              ? 36.h
                                              : 117.h),
                                    );
                                  },
                                ),
                                Obx(
                                  () => controller.currentRank() != 0
                                      ? Positioned(
                                          left: 12.w,
                                          top: 0 - 28.h,
                                          bottom: 0,
                                          child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: controller.prevPage,
                                              icon: SvgPicture.asset(
                                                  AppImages.backwardArrow),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                                Obx(
                                  () => controller.currentRank() <
                                          controller.participants().length - 1
                                      ? Positioned(
                                          right: 12.w,
                                          top: 0 - 28.h,
                                          bottom: 0,
                                          child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: controller.nextPage,
                                              icon: SvgPicture.asset(
                                                  AppImages.forwardArrow),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _profileInfo({
    required String value,
    required String title,
  }) =>
      SizedBox(
        width: 90.w,
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 24.sp,
                color: AppColors.kFAFBFB,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              title,
              style: AppTextStyle.openRunde(
                fontSize: 14.sp,
                color: AppColors.kFAFBFB,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Align _streakChip({
    required String icon,
    required String title,
    required Color bgColor,
  }) =>
      Align(
        child: Container(
          padding: REdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(12.r),
              right: Radius.circular(12.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                icon,
                height: 18.w,
              ),
              5.horizontalSpace,
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 14.sp,
                  color: AppColors.k3D4445,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
