import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/profile_controller.dart';
import '../repositories/edit_profile_sheet_repo.dart';
import '../widgets/edit_data_sheet.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/streak_chip.dart';

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
                  controller.profile()?.user?.username ?? 'Add Name',
                  style: AppTextStyle.openRunde(
                    color: AppColors.kffffff,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
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
                            AppImages.penIcon,
                            height: 16.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.kFAFBFB,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
          8.verticalSpace,

          /// Streak Chips
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreakChip(
                iconPath: AppImages.trophyIcon,
                title: '${controller.profile()?.user?.totalWins ?? 0} Winner',
                bgColor: AppColors.k09DB84.withValues(alpha: .58),
              ),
              StreakChip(
                iconPath: AppImages.fireIcon,
                title:
                    '${controller.profile()?.user?.winnerStreakCount ?? 0} Days',
                bgColor: AppColors.kFFC300.withValues(alpha: .87),
              ),
              StreakChip(
                iconPath: AppImages.emojiIcon,
                title: 'Funniest',
                bgColor: AppColors.kEE4AD1.withValues(alpha: .88),
              ),
            ],
          ),
          24.verticalSpace,

          /// Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileInfoCard(
                value: '${controller.profile()?.round?.winsCount ?? 0}',
                title: 'Wins',
              ),
              ProfileInfoCard(
                value: '${controller.profile()?.round?.totalRound ?? 0}',
                title: 'Rounds',
              ),
              const ProfileInfoCard(
                value: '91',
                title: 'Reactions',
              ),
            ],
          ),
          152.verticalSpace,
        ],
      );
}
