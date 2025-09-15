import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/profile_controller.dart';
import '../repositories/edit_profile_sheet_repo.dart';
import '../widgets/edit_data_sheet.dart';
import '../widgets/profile_info_card.dart';

/// PROFILE HEADER
class ProfileHeaderSection extends StatelessWidget {
  /// Constructor
  const ProfileHeaderSection({
    required this.controller,
    super.key,
  });

  /// ProfileHeaderSection Constructor
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          /// Username + Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => EditProfileSheetRepo.openEditProfile(
                  const EditDataSheet(),
                ),
                child: Text(
                  controller.profile().user?.username ?? 'Add Name',
                  style: AppTextStyle.openRunde(
                    color: AppColors.kffffff,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    shadows: <Shadow>[
                      BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                        color: AppColors.k000000.withValues(alpha: .75),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isCurrentUser) ...<Widget>[
                4.horizontalSpace,
                GestureDetector(
                  onTap: () => EditProfileSheetRepo.openEditProfile(
                    const EditDataSheet(),
                  ),
                  child: Obx(
                    () => controller.isLoading()
                        ? Padding(
                            padding: REdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                color: AppColors.kffffff,
                                strokeWidth: 3.w,
                              ),
                            ),
                          )
                        : SvgPicture.asset(
                            AppImages.penShadowIcon,
                          ).paddingOnly(top: 20.h),
                  ),
                ),
              ],
            ],
          ),
          16.verticalSpace,
          if (_canShowBadge &&
              (controller.currentBadge()?.badge?.isNotEmpty ??
                  false)) ...<Widget>[
            Align(
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.HALL_OF_FAME,
                    arguments: controller.badges,
                  );
                },
                child: IntrinsicWidth(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          8.horizontalSpace,
                          PhysicalModel(
                            color: Colors.transparent,
                            shadowColor: Colors.black.withValues(alpha: 0.75),
                            elevation: 2,
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              height: 22.h,
                              padding: REdgeInsets.only(right: 8, left: 20),
                              alignment: AlignmentDirectional.centerEnd,
                              decoration: BoxDecoration(
                                color: AppColors.kF1F2F2.withValues(alpha: .36),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(12.r),
                                  right: Radius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                controller.currentBadge()?.badge ?? 'No Badge',
                                style: GoogleFonts.fredoka(
                                  color: AppColors.kffffff,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                          height: 24.h,
                          width: 24.w,
                          padding: REdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                AppColors.kFB46CD,
                                AppColors.k6C75FF,
                                AppColors.k0DBFFF,
                              ],
                            ),
                          ),
                          child: SvgPicture.asset(
                            controller.currentBadge()?.imageUrl ??
                                AppImages.bronze,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            24.verticalSpace,
          ],

          // /// Streak Chips
          // if (_canShowBadge() ||
          //     _canShowDailyFvf() ||
          //     _canShowWinnerStreak()) ...<Widget>[
          //   Row(
          //     spacing: 8.w,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       if (_canShowWinnerStreak()) ...<Widget>[
          //         StreakChip(
          //           onTap: () {
          //             Get.toNamed(Routes.HALL_OF_FAME);
          //           },
          //           iconPath: AppImages.trophyIcon,
          //           title:
          //               '${controller.profile().user?.winnerStreakCount ?? 0}x Winner',
          //           bgColor: AppColors.k09DB84.withValues(alpha: .58),
          //         ),
          //       ],
          //       if (_canShowDailyFvf()) ...<Widget>[
          //         StreakChip(
          //           onTap: () {
          //             Get.toNamed(Routes.HALL_OF_FAME);
          //           },
          //           iconPath: AppImages.fireIcon,
          //           title:
          //               '${controller.profile().user?.dailyTeamFvfCount ?? 0} Days',
          //           bgColor: AppColors.kFFC300.withValues(alpha: .87),
          //         ),
          //       ],
          //       if (_canShowBadge()) ...<Widget>[
          //         StreakChip(
          //           onTap: () {
          //             Get.toNamed(Routes.HALL_OF_FAME);
          //           },
          //           iconPath: AppImages.emojiIcon,
          //           title: controller.profile().user?.badge ?? '',
          //           bgColor: AppColors.kEE4AD1.withValues(alpha: .88),
          //         ),
          //       ],
          //     ],
          //   ),
          //   24.verticalSpace,
          // ],

          /// Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileInfoCard(
                value: '${controller.profile().round?.winsCount ?? 0}',
                title: 'Wins',
              ),
              ProfileInfoCard(
                value: '${controller.profile().round?.totalRound ?? 0}',
                title: 'Rounds',
              ),
              ProfileInfoCard(
                value: '${controller.profile().user?.emojiCount ?? 0}',
                title: 'Reactions',
              ),
            ],
          ),
          152.verticalSpace,
        ],
      );

  bool get _canShowBadge =>
      controller.currentBadge() != null &&
      (controller.currentBadge()?.badge != null &&
          (controller.currentBadge()?.badge?.isNotEmpty ?? false));

// bool _canShowBadge() =>
//     controller.profile().user?.badge != null &&
//     (controller.profile().user?.badge?.isNotEmpty ?? false);
//
// bool _canShowDailyFvf() =>
//     (controller.profile().user?.dailyTeamFvfCount ?? 0) > 0;
//
// bool _canShowWinnerStreak() =>
//     (controller.profile().user?.winnerStreakCount ?? 0) > 0;
}
