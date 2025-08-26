import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';
import 'package:fvf_flutter/app/modules/profile/repositories/edit_profile_sheet_repo.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/edit_data_sheet.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/profile_image_card.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

/// EditProfileView
class EditProfileView extends GetView<ProfileController> {
  /// EditProfile Constructor
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => IgnorePointer(
          ignoring: false ?? controller.isEditing(),
          child: Scaffold(
            backgroundColor: AppColors.kF5FCFF,
            body: GradientCard(
              child: Stack(
                children: <Widget>[
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
                        16.verticalSpace,
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
                                () => Column(
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
                                                EditProfileSheetRepo
                                                    .openEditProfile(
                                                  const EditDataSheet(),
                                                );
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
                                    16.verticalSpace,
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
                                    Center(
                                      child: Container(
                                        height: 100.w,
                                        width: 100.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.kF1F2F2,
                                        ),
                                        child: ProfileImageCard(
                                          placeholderAsset:
                                              AppImages.profilePlaceholder,
                                          imageUrl: controller
                                                  .profile()
                                                  ?.user
                                                  ?.profileUrl ??
                                              '',
                                        ),
                                      ),
                                    ),
                                    16.verticalSpace,
                                    Text(
                                      'add profile pic',
                                      style: AppTextStyle.openRunde(
                                        fontSize: 15.sp,
                                        color: AppColors.kC0C8C9,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(
                                          minWidth: 56.w, minHeight: 56.w),
                                      onPressed: () {
                                        controller.pageController
                                            .jumpToPage(1);
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
                                ).paddingSymmetric(horizontal: 24.w),
                              ),
                              Stack(
                                children: <Widget>[
                                  PageView.builder(
                                    controller:
                                        controller.participantPageController,
                                    itemCount:
                                        controller.participants().length,
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
                                                              imageUrl:
                                                                  participant
                                                                          .selfieUrl ??
                                                                      '',
                                                              width: 24.w,
                                                              height: 24.w,
                                                              fit: BoxFit
                                                                  .cover,
                                                              placeholder: (_,
                                                                      __) =>
                                                                  const Center(
                                                                      child: CircularProgressIndicator(
                                                                          strokeWidth:
                                                                              2)),
                                                              errorWidget: (_,
                                                                      __,
                                                                      ___) =>
                                                                  const Center(
                                                                child: CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2),
                                                              ),
                                                            ),
                                                          ),
                                                          4.horizontalSpace,
                                                          Flexible(
                                                            child: Text(
                                                              participant
                                                                      .userData
                                                                      ?.username ??
                                                                  '',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: AppTextStyle
                                                                  .openRunde(
                                                                fontSize:
                                                                    24.sp,
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
                                                onPressed:
                                                    controller.prevPage,
                                                icon: SvgPicture.asset(
                                                    AppImages.backwardArrow),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  Obx(
                                    () => controller.currentRank() <
                                            controller.participants().length -
                                                1
                                        ? Positioned(
                                            right: 12.w,
                                            top: 0 - 28.h,
                                            bottom: 0,
                                            child: Center(
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                                onPressed:
                                                    controller.nextPage,
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
